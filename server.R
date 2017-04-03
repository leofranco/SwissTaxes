library(scales)
library(shiny)
library(data.table)
library(ggplot2)

filename <-"data/r16all_filtered.txt"
file.df <- read.csv(filename, stringsAsFactors=F, header=TRUE, sep=",", colClasses=c("character","character","numeric","character","numeric","numeric","numeric","numeric"))

file.dt <- data.table(file.df)
setkey(file.dt,Rate,Children,Church)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$taxPlot <- renderPlot({
    
    church<-ifelse(input$church==2,"N","Y")
    
    taxrate<-"A"
    if(input$rate==1){taxrate<-"A"}
    else if(input$rate==2){taxrate<-"B"}
    else if(input$rate==3){taxrate<-"C"}
    
    results.dt <- file.dt[list(taxrate,input$children,church)]
    results.dt  <- results.dt[results.dt$From<=input$salary & results.dt$To>=input$salary,]
    
    if(input$perfrancs==1){
      results.dt$TaxPer <- results.dt$TaxPer/100
      #Next line is necesary to print bars in right order (and it hast to be a data frame)
      results.df <- data.frame(results.dt)
      results.df$Canton <- factor(results.df$Canton, levels=results.df[order(-results.df$TaxPer), "Canton"])
      ggplot(data=results.df, aes(x=Canton, y=TaxPer, fill=Canton)) + geom_bar( stat="identity") + geom_text(aes(label = paste(sprintf("%.1f%%", TaxPer*100), sep=""), y = TaxPer, x=Canton), size = 2, position = position_dodge(width=0.9), vjust=-0.25) + guides(fill=FALSE) + xlab("") + ylab("") + ggtitle("") + scale_y_continuous(labels = percent) 
    }
    else if(input$perfrancs==2){
      # If we want to show the results in swiss francs
      results.dt$TaxPer <- results.dt$TaxPer/100
      results.dt$TaxFr <- round( (results.dt$From+results.dt$To)/2*results.dt$TaxPer,0)
      results.df <- data.frame(results.dt)
      results.df$Canton <- factor(results.df$Canton, levels=results.df[order(-results.df$TaxPer), "Canton"])
      ggplot(data=results.df, aes(x=Canton, y=TaxFr, fill=Canton)) + geom_bar( stat="identity") + geom_text(aes(label = TaxFr, y = TaxFr, x=Canton), size = 2, position = position_dodge(width=0.9), vjust=-0.25) + guides(fill=FALSE) + xlab("") + ylab("") + ggtitle("")     
    }
})

})