//
//  EmojiTableViewController.swift
//  EmojiProject
//
//  Created by Светлана Мухина on 29.10.2021.
//

import UIKit

class EmojiTableViewController: UITableViewController {
    
    var objects = [Emoji(emoji: "🖤", name: "Friend", description: "Best friends forever", isFavorite: false), Emoji(emoji: "💛", name: "Sun", description: "My mood is sunshine", isFavorite: true), Emoji(emoji: "💜", name: "Fake love", description: "Don't fall in love with you", isFavorite: false), Emoji(emoji: "❤️", name: "Love", description: "Feeling of sincere love", isFavorite: true)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.title = "Emoji Reader"
        self.navigationItem.leftBarButtonItem = self.editButtonItem  //слева кнопка эдит
       // editButtonItem.title = "Удалить"   //работает только при загрузке приложения
       // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell") //регистрация новой ячейки
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    } //число секций
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objects.count
    } //число строк в секции
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emojiCell", for: indexPath) as! EmojiTableViewCell
        let object = objects[indexPath.row]
        cell.set(object: object)
       // cell.emojiLabel.text = "❤️‍🔥" //изменяем дефолтные значения из main.storyboard
        return cell
    }  //конфигурации ячейки
    
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
//        if indexPath.row % 2 == 0{
//            return .delete
//        } else {
//            return .insert
//        }
    }  //настраиваем появление кнопки удаления по нажатию на эдит
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            print("123")
//        } else {
//            print("321")
//        }
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    } //удалаем по кнопке удаление
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue){
        guard segue.identifier == "saveSegue" else {return}
        let sourceVC = segue.source as! AddNewEmojiTableViewController
        let emoji = sourceVC.emoji
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow{  //если существует уже выбранная ячейка
            objects[selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
        }else{
        let newIndexPath = IndexPath(row: objects.count, section: 0)
        objects.append(emoji)
            tableView.insertRows(at: [newIndexPath], with: .fade)
            
        }
    } //unwind segue от 2-го экрана при нажатии сохранить редактирование
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "editEmoji" else {return}
        let indexPath = tableView.indexPathForSelectedRow
        let emoji = objects[indexPath!.row]
        let navigationVC = segue.destination as! UINavigationController
        let newEmojiVC = navigationVC.topViewController as! AddNewEmojiTableViewController
        newEmojiVC.emoji = emoji
        newEmojiVC.title = "Edit"
    } //редактирование уже заполненых ячеек
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }  //добавление возможности перемещения
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedEmoji = objects.remove(at: sourceIndexPath.row)
        objects.insert(movedEmoji, at: destinationIndexPath.row)
        tableView.reloadData()
    } //что будет происходить при перемещении ячеек
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)
        let favorite = favoriteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done,favorite])
    } //слева по свайпу новые действия появляются
    
    func  doneAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Done") { (action, view, completion) in
            self.objects.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        action.backgroundColor = .systemBlue
        action.image = UIImage(systemName: "checkmark.seal")
        return action
    } //функция по нажатию на которую будет происходить удаление объекта (галочка)
    func  favoriteAction(at indexPath: IndexPath) -> UIContextualAction {
        var object = objects[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Like") {(action, view, completion) in
            object.isFavorite = !object.isFavorite
            self.objects[indexPath.row] = object
            completion(true)
        }
        action.backgroundColor = object.isFavorite ? .systemPink : .systemGray
        action.image = UIImage(systemName: "heart")
        return action
    } //функция которая ставит лайк ячейке таблицы
    
}
