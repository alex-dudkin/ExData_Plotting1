#memory required = no. of column * no. of rows * 8 bytes/numeric
#memory_required = 2075259 * 9 * 8/1024/1024 #Megabytes
Sys.setlocale("LC_TIME","en_US.UTF-8")

f1 <- file("household_power_consumption.txt", open = "rt")
ptrn <- "^1\\/2\\/2007|^2\\/2\\/2007"

skip1 <- 0
bingo <- 0

while (length(ln <- readLines(f1, n=1)) > 0) {
        if (grepl(ptrn, ln)) {
                bingo <- 1
                break
        }
        skip1 <- skip1+1
}

while (length(ln <- readLines(f1, n=1)) > 0) {
        if (!grepl(ptrn, ln)) {
                break
        }
        bingo <- bingo+1
}
close(f1)

t1 <- read.csv("household_power_consumption.txt", header = FALSE, sep = ";", skip = skip1, nrows = bingo, na.strings = "?")
h1 <- read.csv("household_power_consumption.txt", header = TRUE, sep = ";", nrows = 1)
colnames(t1) <- colnames(h1)
t1$DateTime <- strptime(paste(t1$Date, t1$Time, sep=" "), format = "%d/%m/%Y %H:%M:%S")

fname <- "plot4.png"
png(fname, width=480, height=480)
par(mfrow=c(2,2))
#1
plot(t1$DateTime, t1$Global_active_power, type = "l", xlab = "", ylab="Global Active Power")
#2
plot(t1$DateTime, t1$Voltage, type = "l", xlab = "datetime", ylab="Voltage")
#3
plot(t1$DateTime, t1$Sub_metering_1 , type = "l", xlab="", ylab = "Energy sub metering", col=1)
lines(t1$DateTime, t1$Sub_metering_2, col=2)
lines(t1$DateTime, t1$Sub_metering_3, col=4)
legend("topright", legend = paste0("Sub_metering_", 1:3), col=c(1,2,4), lwd = 1, cex = 1, bty = "n")
#4
plot(t1$DateTime, t1$Global_reactive_power, type = "l", xlab="datetime",  ylab = "Global_reactive_power")
dev.off()
