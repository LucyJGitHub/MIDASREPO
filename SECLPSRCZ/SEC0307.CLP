/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Pledge Security Switch Rpt-Mode L')          */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0307   PLEDGED SECURITY SWITCH RPT                      */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01117             Date 10Dec90              */
/*                      S01179             Date 16/12/88             */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*   S01117 - MULTIBRANCHING                                        */
/*   S01179 - INCORPORATION                                     */
/*   S01176 - SECURITIES TRADING 3.1 (NEW PROGRAM)                  */
/*                                                                  */
/********************************************************************/
/**/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                       *S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
/**/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)
 
/*           DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)             */ /*S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(60)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
 
 
 
/* SETUP AND SEND PGM MESSAGE                          */
 
 
             CHGVAR     VAR(&MSG) VALUE('SEC0307 - Input Cycle +
                          Pledge Security Report')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* SET OFF SWITCHES                                    */
 
             CHGJOB     SWS(00000000)
 
/* CALL PROGRAM SE5990                                 */
 
/************CALL       PGM(SE5990) PARM('L')                        * *S01117*/
             CALL       PGM(SE5990) PARM('L' &RSEQ)                   /*S01117*/
 
/* ERROR HANDLING ROUTINE                             */
 
ERROR:     IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*            RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)         */ /*S01117*/
              RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)            /*S01117*/
              SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                         TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
              CHGVAR     VAR(&MEM) VALUE('SEC5990 - File Controls out +
                         of Balance')
              SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) +
                         TOMSGQ(MOPERQ MRUNQ)
           ENDDO
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
           ENDPGM
