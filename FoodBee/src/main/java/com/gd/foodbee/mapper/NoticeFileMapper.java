package com.gd.foodbee.mapper;

import org.apache.ibatis.annotations.Mapper;

import com.gd.foodbee.dto.NoticeFileDTO;

@Mapper
public interface NoticeFileMapper {
	//공지사항 파일 추가
	//파라미터값=noticeFileDTO
	//사용클래스
	//1.noticeService.addnotice
	//2.noticeService.getModifyNoticeList
	int insertNoticeFile(NoticeFileDTO noticeFileDTO);
	//공지사항 파일 삭제
	//파라미터값=noticeFileDTO
	//사용클래스=noticeService.getModifyNoticeList
	int deleteNoticeFile(NoticeFileDTO noticeFileDTO);
	
}
