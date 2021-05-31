//
//  IntialVM.swift
//  Vajro_Task
//
//  Created by Sethuram Vijayakumar on 26/05/21.
//

import Foundation
import UIKit

// #MARK:- Intiating View Model
class  IntialVM {
    var onGetArticleData:((Model)->Void)?
    var vc : UIViewController!
    init(){}
    
    init(vc : UIViewController) {
        self.vc = vc
    }
}



// #MARK:- ViewModel Extension for Home View Controller
extension IntialVM{
    func getModelResponse(){
            let resource = Resource<Model>(url: url, method: .get ,params : [:])
            WebService.shared.loadData(resource: resource, complition: {  (result , statusCode)  in
                switch result{
                    case .success(let data) :
                        if statusCode.isResponseOK() {
                            self.onGetArticleData?(data)
                        }else{
                            showToast(msg: "Oops! Something went Wrong")
                        }
                        break
                    case .failure(let error) :
                        Log.er(url : url,error.localizedDescription)
                        break
                }
            })
        }
    
    
    func  getAttributedText(model:Model?,index:Int) -> NSAttributedString  {
        let attributedText = NSMutableAttributedString(string: "\(model?.articles?[index].title ?? "")", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)])
 if let str = model?.articles?[index].summary_html?.withoutHtmlTags() {
     if !(model?.articles?[index].summary_html?.isEmpty ?? false){
         attributedText.append(NSMutableAttributedString(string: "\n\n\(str)", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]))
     }
 }
        return attributedText
    }
    
    func setHeightConstraints(contentHeight:CGFloat,width:Int,height:Int) -> CGFloat{
        let ratio = Double(height) / Double(width)
        let newHeight = contentHeight * CGFloat(ratio)
        return CGFloat(newHeight)
    }
    
    func pushToNewViewController(htmlString:String){
        let webLoadVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "WebViewController") as! WebViewController
        webLoadVc.htmlString = htmlString
        self.vc.navigationController?.pushViewController(webLoadVc, animated: true)
    }
    
}


extension IntialVM{
    
    func loadHtmlData( str: String) {
        let webLoadVc = self.vc as! WebViewController
        webLoadVc.webView.loadHTMLString(str, baseURL: nil)
    }
}

