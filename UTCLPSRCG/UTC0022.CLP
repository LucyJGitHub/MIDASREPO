/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Print message queue')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0022 - Print message queue if not empty                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG018886           Date 22May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK018  *MOVED     Date 26Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01526             Date 01Dec94              */
/*                      S01516             Date 19Jul94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                         */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       S01526 - Midas Upgrade utility, improved report             */
/*       S01516 - Incorporation of enhanced CRTOBJ into core         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MSGQ)
 
             DCL        VAR(&MSGQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(128)                /*S01526*/
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(128)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*    Global monitor message                                       */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*    Check for messages present                                   */
/*********** RCVMSG     MSGQ(&MSGQ) MSGTYPE(*NEXT) MSGKEY(*TOP) +     /*S01526*/
/***********              RMV(*NO) MSGDTA(&MSGDTA)                    /*S01526*/
             RCVMSG     MSGQ(&MSGQ) MSGTYPE(*NEXT) MSGKEY(*TOP) +
                          RMV(*NO) MSG(&MSG) MSGDTA(&MSGDTA)          /*S01526*/
 
/*********** IF         COND(&MSGDTA****' ') THEN(DO)                 /*S01526*/
/*********** DSPMSG     MSGQ(&MSGQ) OUTPUT(*PRINT) START(*FIRST)      /*S01526*/
/**********  IF         COND(&MSG****' '***&MSGDTA****' ') THEN(DO)*/   /*S01526 BG18886*/
             IF         COND(&MSG *NE ' ' *OR &MSGDTA *NE ' ') THEN(DO) /*S01526 BG18886*/
                OVRPRTF    FILE(UT0022P1) SPLFNAME(&MSGQ)             /*S01526*/
                CALL       PGM(UT0022) PARM(&MSGQ)                    /*S01526*/
             ENDDO
             GOTO       CMDLBL(END)
 
 ABNOR:
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
