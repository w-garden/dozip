package com.dozip.controller.partners;

import com.dozip.service.partners.myInterior.MyInteriorService;
import com.dozip.vo.ContractVO;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;

@Controller
@RequestMapping("partners/*")
public class MyInteriorController {
    @Autowired
    MyInteriorService myInteriorService;

    @RequestMapping(value = "/interior_list") //내공사내역
    public ModelAndView interior_list(String est_check, String pay_state, HttpSession session) {
        List<ContractVO> clist = myInteriorService.getContract_interior((String)session.getAttribute("businessNum"));
        if(est_check != null){
            System.out.println(est_check);
        }
        if(pay_state != null){
            System.out.println(pay_state);
        }
        System.out.println(clist);
        ModelAndView mv = new ModelAndView( "/partners/myinterior/interior_List");
        mv.addObject("clist", clist);
        return mv;
    }
    @RequestMapping(value = "/show_contract") //견적서 보기
    public ModelAndView show_contract(String cont_no){
        ModelAndView mv = new ModelAndView("/partners/myinterior/contract_res");
        mv.addObject("cv", myInteriorService.show_contract(cont_no));
        return mv;
    }

    @RequestMapping(value = "/schedule_list") //내공사 일정
    public ModelAndView schedule_list(HttpSession session) throws JsonProcessingException {

        List<ContractVO> slist = myInteriorService.getschedule((String) session.getAttribute("businessNum"));

        String json = new ObjectMapper().writeValueAsString(slist);
        System.out.println(slist);
        System.out.println(json);
        ModelAndView mv = new ModelAndView("/partners/myinterior/schedule_List");
        mv.addObject("json", json);
        return mv;
    }

    @RequestMapping(value="/schedule_regit")//ajax로 일정 등록
    @ResponseBody
    public HashMap<String,Object> schedule_regit(String cont_no){
        HashMap<String ,Object> resultMap = new HashMap<>();
        int result = myInteriorService.regit_schedule(cont_no);
        resultMap.put("status",result);
    return resultMap;
    }

    @RequestMapping(value = "/balance_details") //정산 내역
    public String balance_details() {
        return "/partners/myinterior/balance_details";
    }
}