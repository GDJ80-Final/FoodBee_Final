package com.gd.foodbee.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.gd.foodbee.dto.EmpDTO;
import com.gd.foodbee.dto.LoginDTO;
import com.gd.foodbee.dto.NoticeRequest;
import com.gd.foodbee.service.LoginService;
import com.gd.foodbee.service.NoticeService;
import com.gd.foodbee.util.TeamColor;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class NoticeController {
	@Autowired NoticeService noticeService;
	
	@GetMapping("/noticeList")//전체List
	public String noticeList(
			@RequestParam(name="currentPage", defaultValue="1") int currentPage,
			@RequestParam(name="rowPerPage", defaultValue="10") int rowPerPage,
			Model model, HttpSession session) {

		EmpDTO emp = (EmpDTO) session.getAttribute("emp");
		int empNo = 0;
		String dptNo = null;
		String rankName = null;
		
	    if (emp != null) {
	        log.debug(TeamColor.PURPLE + "emp => " + emp);
	        empNo = emp.getEmpNo();
	        dptNo = emp.getDptNo();
	        rankName = emp.getRankName();
	        log.debug(TeamColor.PURPLE + "empNo => " + empNo);
	        log.debug(TeamColor.PURPLE + "dptNo => " + dptNo);
	        log.debug(TeamColor.PURPLE + "rankName=>" + rankName);
	    } else {
	        log.debug(TeamColor.PURPLE + "로그인하지 않았습니다");
	    }
		
		log.debug(TeamColor.PURPLE + "currentPage =>" + currentPage );
		log.debug(TeamColor.PURPLE + "rowPerPage =>" + rowPerPage);
		
		List<HashMap<String,Object>> list = noticeService.getNoticeList(currentPage, rowPerPage, dptNo);
		
		log.debug(TeamColor.PURPLE + "list=>" + list);
		
		//총 공지사항의 갯수
		int cntNotice = noticeService.getCountNoticeList();
		log.debug(TeamColor.PURPLE + "cntNotice=>" + cntNotice);
		
		model.addAttribute("dptNo", dptNo);
		model.addAttribute("rankName", rankName);
		model.addAttribute("list", list);
	return "noticeList";
	}
	
	@GetMapping("/allNoticeList")//[버튼]전체 공지사항
	@ResponseBody
	public List<HashMap<String,Object>> allNoticeList(int currentPage, int rowPerPage, String dptNo) {
		List<HashMap<String,Object>> list = noticeService.getNoticeList(currentPage, rowPerPage, dptNo);
		log.debug(TeamColor.PURPLE + "list=>" + list);		
		return list;
	}
	
	@GetMapping("/allEmpList")//[버튼]전사원 공지사항
	@ResponseBody
	public List<HashMap<String,Object>> allEmpList(int currentPage, int rowPerPage) {
		List<HashMap<String,Object>> allEmpList = noticeService.getAllEmpNoticeList(currentPage, rowPerPage);
		log.debug(TeamColor.PURPLE + "allEmpList=>" + allEmpList);
		
		return allEmpList;
	}
	@GetMapping("/allDptList")//[버튼]부서별 공지사항
	@ResponseBody
	public List<HashMap<String,Object>>allDptList(int currentPage, int rowPerPage, String dptNo) {
		List<HashMap<String,Object>> allDptList = noticeService.getAllDptNoticeList(currentPage, rowPerPage, dptNo);
		log.debug(TeamColor.PURPLE + "allDptList=>" + allDptList);
		
		return allDptList;
	}
	
	@GetMapping("/addNotice")//공지사항 추가
	public String addNotice(Model model, HttpSession session) {
		EmpDTO emp = (EmpDTO) session.getAttribute("emp");
		int empNo = 0;
		String dptNo = null;
		String empName = null;
		
	    if (emp != null) {
	        log.debug(TeamColor.PURPLE + "emp => " + emp);
	        empNo = emp.getEmpNo();
	        empName = emp.getEmpName();
	        dptNo = emp.getDptNo();
	        log.debug(TeamColor.PURPLE + "empNo => " + empNo);
	        log.debug(TeamColor.PURPLE + "dptNo => " + dptNo);
	        log.debug(TeamColor.PURPLE + "empName=>" + empName);
	    } else {
	        log.debug(TeamColor.PURPLE + "로그인하지 않았습니다");
	    }
	    
	    model.addAttribute("dptNo", dptNo);
	    model.addAttribute("empNo", empNo);
	    model.addAttribute("empName", empName);
	return "addNotice";
	}
	
	@PostMapping("/addNoticeAction")//공지사항 추가action
	public String addNoticeAction(NoticeRequest noticeRequest) {
		log.debug(TeamColor.PURPLE + "noticeRequest=>" + noticeRequest);
		
		noticeService.addNotice(noticeRequest);
		
	return"redirect:/noticeList";
	}
	@GetMapping("/noticeOne")
    public String noticeOne(
    		@RequestParam("noticeNo") int noticeNo,
    		Model model) {
   
		log.debug(TeamColor.PURPLE + "noticeOne.noticeNo=>" + noticeNo);
		
		List<Map<String, Object>> one = noticeService.getNoticeOne(noticeNo);
		log.debug(TeamColor.PURPLE + "noticeOne.one=>" + one);
		
		model.addAttribute("one", one);
		
    return "noticeOne"; 
    }
	
	@PostMapping("/deleteNotice")
	public String deleteNotice(@RequestParam("noticeNo") int noticeNo) {
		log.debug(TeamColor.PURPLE + "delete.noticeNo=>" + noticeNo);
		
		noticeService.getDeleteNotice(noticeNo);
	return"redirect:/noticeList";
	}
}