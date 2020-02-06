/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Position Settlements Overdue Rpt.')          */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC0612I  POSITION SETTLEMENTS OVERDUE REPORT              */
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
/*       Prev Amend No. S01117             Date 08Jan91              */
/*                      E15626             Date 11/10/88             */
/*                      S01179                  DATE  16/09/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       S01117 - MULTIBRANCHING                                    */
/*       E15626 - Message variable for MRUNQ increased in length.   */
/*       S01179 -  RELEASE                                       */
/*                                                                  */
/********************************************************************/
 
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
             DCL        VAR(&LDA)     TYPE(*CHAR)  LEN(256)           /*S01179*/
 
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)           */  /*E15626*/
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(46)        *E15626* *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
 
/* SETUP AND SEND PGM MESSAGE                                    */
 
             CHGVAR     VAR(&MEM) VALUE('SEC0612I - Position +
                        Settlements Overdue Report')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* CLEAR SWITCHES                                                */
 
             CHGJOB SWS(00000000)
 
/* CALL PROGRAM                                                  */
 
             CALL       PGM(SE0680)
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)         * *S01117*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR    VAR(&MEM) VALUE('SEC0612I - Job Terminated, +
                          Database in Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* FOR FILE CONTROLS OUT OF BALANCE ERROR                        */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                CHGVAR  VAR(&MEM) VALUE('SEC0612I - File Controls Out +
                        Of Balance')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/*ENDPGM:******ENDPGM                                                * *S01117*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
