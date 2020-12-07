import Cocoa
import CreateML

let seed = 9
let percentage = 0.8
let textColumn = "text"
let labelColumn = "class"

let data = try MLDataTable(contentsOf: URL(fileURLWithPath: "/Users/pan/Estudos/CursoSwift_TwitterGenius/twitter-data.csv"))


// MARK: Dividing Testing and Training Data

let(trainingData, testingData) = data.randomSplit(by: percentage, seed: seed)


// MARK: Creating Classifiers

let sentimentClassifier = try MLTextClassifier(trainingData: trainingData, textColumn: textColumn, labelColumn: labelColumn)


// MARK: Testing and getting results

let evaluationMetrics = sentimentClassifier.evaluation(on: testingData, textColumn: textColumn, labelColumn: labelColumn)

let evaluationAccuracy = (1.0 - evaluationMetrics.classificationError) * 100


// MARK: Saving Model

let metadata = MLModelMetadata(author: "João Pedro Giarrante", shortDescription: "A model trained to classify sentiment on Tweets", version: "1.0")

try sentimentClassifier.write(to: URL(fileURLWithPath: "/Users/pan/Estudos/CursoSwift_TwitterGenius/TwitterGeniusClassifier.mlmodel"))


try sentimentClassifier.prediction(from: "@Apple where can I find your site?")

try sentimentClassifier.prediction(from: "@Cocacola sucks!")

try sentimentClassifier.prediction(from: "i love @MacDonalds!")
