#memory required = no. of column * no. of rows * 8 bytes/numeric
#memory_required = 2075259 * 9 * 8/1024/1024 #Megabytes

f1 <- file("household_power_consumption.txt", open = "rt")
f1_read <- TRUE
skip1 <- -1
while (f1_read) {
        ln <- readLines(f1, n=1)
        f1_read <- !grepl("^1\\/2\\/2007|^2\\/2\\/2007", ln)
        skip1 <- skip1+1
}

f1_read <- TRUE
skip2 <- 0
while (f1_read) {
        ln <- readLines(f1, n=1)
        f1_read <- grepl("^1\\/2\\/2007|^2\\/2\\/2007", ln)
        skip2 <- skip2+1
}
close(f1)

t1 <- read.csv("household_power_consumption.txt", header = FALSE, sep = ";", skip = skip1, nrows = skip2, na.strings = "?")
h1 <- read.csv("household_power_consumption.txt", header = TRUE, sep = ";", nrows = 1)
colnames(t1) <- colnames(h1)
t1$DateTime <- strptime(paste(t1$Date, t1$Time, sep=" "), format = "%d/%m/%Y %H:%M:%S")

png("plot1.png")
hist(t1$Global_active_power, freq = TRUE, col="red", main="Global Active Power",xlab="Global Active Power (kilowatts)")
dev.off()
