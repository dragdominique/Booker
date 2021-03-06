//
//  ReadingHabitsBrain.swift
//  Booker - Book Tracker
//
//  Created by Dominik Drąg on 27/10/2020.
//  Copyright © 2020 Dominik Drąg. All rights reserved.
//

import Foundation
import RealmSwift

class ReadingEntriesBrain {
	private static let realm = RealmController.getReadingEntriesRealm()
	
	private static var readingEntries: [ReadingEntryModel] = []
	
	static func addReadingEntry(_ entry: ReadingEntryModel) {
		try! realm.write {
			realm.add(entry)
		}
	}
	
	static func deleteEntry(_ entry: ReadingEntryModel) {
		try! realm.write {
			realm.delete(entry)
		}
		loadReadingEntriesFromRealm()
	}
	
	static func getEntries() -> [ReadingEntryModel] {
		return readingEntries
	}
	
	static func addPagesToEntry(with date: String, pages: Int) {
		let entry = getReadingEntry(with: date)
		if (entry.pages + pages) >= 0 {
			try! realm.write {
				entry.pages += pages
			}
		} else {
			try! realm.write {
				entry.pages = 0
			}
		}
		
		loadReadingEntriesFromRealm()
	}
	
	static func addBooksToEntry(with date: String, books: Int) {
		let entry = getReadingEntry(with: date)
		try! realm.write {
			entry.books += 1
		}
		
		loadReadingEntriesFromRealm()
	}
	
	private static func readingEntriesContainEntry(with date: String) -> Bool {
		var contains = false
		for entry in readingEntries {
			if entry.date == date {
				contains = true
			}
		}
		return contains
	}
	
	private static func getReadingEntry(with date: String) -> ReadingEntryModel {
		for entry in readingEntries {
			if entry.date == date {
				return entry
			}
		}
		
		let entry = ReadingEntryModel(date: date, pages: 0, books: 0)
		addReadingEntry(entry)
		return entry
	}
	
	static func getPagesPerMonth(month: String, year: String) -> Int {
		var pages = 0
		for entry in readingEntries {
			if entry.getDatePart(part: "month") == month && entry.getDatePart(part: "year") == year {
				pages += entry.pages
			}
		}
		
		return pages
	}
	
	static func getBooksNumberPerMonth(month: String, year: String) -> Int {
		var booksNumber = 0
		for entry in readingEntries {
			if entry.getDatePart(part: "month") == month && entry.getDatePart(part: "year") == year {
				booksNumber += entry.books
			}
		}
		
		return booksNumber
	}
	
	//MARK: - Realm
	
	static func saveReadingEntriesToRealm() {
		try! realm.write {
			realm.deleteAll()
			for entry in readingEntries {
				realm.add(entry)
			}
		}
	}
	
	static func loadReadingEntriesFromRealm() {
		readingEntries.removeAll()
		let loadedEntries = realm.objects(ReadingEntryModel.self)
		print(loadedEntries)
		for entry in loadedEntries {
			readingEntries.append(entry)
		}
	}
}
