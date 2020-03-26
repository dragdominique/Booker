//
//  BookDetailsViewController.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 18/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import UIKit

class BookDetailsViewController: UIViewController, AddBookViewControllerDelegate {
    var book: BookModel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var pagesReadLabel: UILabel!
    @IBOutlet weak var totalPagesLabel: UILabel!
    @IBOutlet weak var beginDateLabel: UILabel!
    @IBOutlet weak var finishDateLabel: UILabel!
    
    override func viewDidLoad() {
        titleLabel.text = book.title
        authorLabel.text = book.author
        pagesReadLabel.text = "Pages read: " + String(book.pagesRead)
        totalPagesLabel.text = "Total pages: " + String(book.totalPages)
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        let beginDate = df.string(from: book.beginDate)
        beginDateLabel.text = "Begin date: " + beginDate
        if let safeFinishDate = book.finishDate {
            let stringFinishDate = df.string(from: safeFinishDate)
            finishDateLabel.text = "Finish date: " + stringFinishDate
        } else {
            finishDateLabel.text = ""
        }
    }
    
    @IBAction func editBookDataButtonPressed(_ sender: UIButton) {
        if let addBookViewController = storyboard?.instantiateViewController(identifier: "AddBook") as? AddBookViewController {
            addBookViewController.delegate = self
            addBookViewController.bookTitle = book.title
            addBookViewController.bookAuthor = book.author
            addBookViewController.bookTotalPages = book.totalPages
            addBookViewController.bookPagesRead = book.pagesRead
            addBookViewController.beginDate = book.beginDate
            addBookViewController.finishDate = book.finishDate
            navigationController?.pushViewController(addBookViewController, animated: true)
        }
    }
    
    func handleBookData(title: String, author: String, totalPages: Int, pagesRead: Int, beginDate: Date, finishDate: Date?) {
        book.title = title
        book.author = author
        book.totalPages = totalPages
        book.pagesRead = pagesRead
        book.beginDate = beginDate
        book.finishDate = finishDate
    }
    
}
