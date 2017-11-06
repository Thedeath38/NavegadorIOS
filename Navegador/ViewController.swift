//
//  ViewController.swift
//  Navegador
//
//  Created by Junts Pel Si on 19/10/17.
//  Copyright © 2017 Ultima Fila. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

class ViewController: UIViewController,UIWebViewDelegate,UISearchBarDelegate {
    @IBOutlet weak var viewWeb: UIWebView!
    @IBOutlet weak var sbBusqueda: UISearchBar!
    
    var ref:DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewWeb.loadRequest(URLRequest(url: URL(string: "https://www.google.com")!))
        sbBusqueda.text = "https://www.google.com"
        
        ref=Database.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnRewind(_ sender: UIBarButtonItem) {
        if viewWeb.canGoBack{
            viewWeb.goBack()
        }
    }
    @IBAction func btnFastForward(_ sender: UIBarButtonItem) {
        if viewWeb.canGoForward{
            viewWeb.goForward()
        }
    }
    @IBAction func btnRefresh(_ sender: UIBarButtonItem) {
        viewWeb.reload()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        sbBusqueda.resignFirstResponder()
        if sbBusqueda.text!.contains(".") == false {
            sbBusqueda.text = "https://google.com/search?q=" + (sbBusqueda.text?.replacingOccurrences(of: " ", with: "+"))!
        }
        else
        {
            if sbBusqueda.text!.lowercased().hasPrefix("http://") == true {
                
            }
            else if sbBusqueda.text!.lowercased().hasPrefix("https://") == true {
                
            }
            else {
                sbBusqueda.text = "http://" + sbBusqueda.text!
            }
        }
        if let url = URL(string: sbBusqueda.text!) {
            viewWeb.loadRequest(URLRequest(url:url))
        }else{
            print("Error")
        }
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        sbBusqueda.text = viewWeb.request?.url?.absoluteString
        ref?.child("historial_web").childByAutoId().setValue(viewWeb.request?.url?.absoluteString)
    }
    
}

