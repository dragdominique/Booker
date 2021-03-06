//
//  BookBrain.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 14/03/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import Foundation
import RealmSwift

class BooksBrain {
	private static let realm = RealmController.getBooksRealm()
	
	private static var books: [BookModel] = []
	
	//MARK: - Books functions
	
	static func addBook(_ book: BookModel) {
		try! realm.write {
			realm.add(book)
		}
		loadBooksFromRealm()
	}
	
	static func deleteBook(_ book: BookModel) {
		ImageManager.deleteImage(forKey: book.cover)
		try! realm.write {
			realm.delete(book)
		}
		loadBooksFromRealm()
	}
	
	static func getBooks() -> [BookModel] {
		return books
	}
	
	static func searchBooks(books: [BookModel], by keyword: String) -> [BookModel] {
		if keyword == "" {
			return books
		}
	
		var foundBooks = [BookModel]()
		for book in books {
			if book.author.lowercased().contains(keyword.lowercased()) || book.title.lowercased().contains(keyword.lowercased()) {
				foundBooks.append(book)
			}
		}
		
		return foundBooks
	}
	
	static func getBooksFiltered(books: [BookModel], by filter: String) -> [BookModel] {
		switch filter {
		case "read":
			return ReadingHabits.getBooksRead()
			
		case "reading":
			return ReadingHabits.getBooksInProgress()
			
		case "toRead":
			return ReadingHabits.toRead()
			
		default:
			return books
		}
	}
	
	static func getBooksSorted(books: [BookModel], by order: String) -> [BookModel] {
		switch order {
		case "title":
			return books.sorted {
				$0.title < $1.title
			}
			
		case "author":
			return books.sorted {
				$0.author < $1.author
			}
			
		case "progress":
			return books.sorted {
				$0.getPercentage() < $1.getPercentage()
			}
			
		case "beginDate":
			return books.sorted {
				$0.beginDate < $1.beginDate
			}
			
		case "finishDate":
			return books.sorted {
				$0.finishDate < $1.finishDate
			}
			
		default:
			return books
		}
	}
	
	static func editBookData(_ editedBook: BookModel) {
		try! realm.write {
			realm.add(editedBook, update: .modified)
		}
		loadBooksFromRealm()
	}
	
	static func editBookNotes(book: BookModel, notes: String) {
		try! realm.write {
			realm.create(BookModel.self, value: ["id": book.id, "notes": notes], update: .modified)
		}
	}
	
	static func editBookQuotes(book: BookModel, quotes: List<String>) {
		try! realm.write {
			realm.create(BookModel.self, value: ["id": book.id, "quotes": quotes], update: .modified)
		}
	}
	
	static func getBookProgress(_ book: BookModel) -> CGFloat {
		if book.totalPages == 0 {
			return 0
		}
		let progress = (CGFloat(book.pagesRead) / CGFloat(book.totalPages))
		return progress
	}
	
	//MARK: - Realm
	
	static func saveBooksToRealm() {
		try! realm.write {
			realm.deleteAll()
			for book in books {
				realm.add(book)
			}
		}
	}
	
	static func loadBooksFromRealm() {
		books.removeAll()
		let loadedBooks = realm.objects(BookModel.self)
		print(loadedBooks)
		for book in loadedBooks {
			books.append(book)
		}
	}
}
