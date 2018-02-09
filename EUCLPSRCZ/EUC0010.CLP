/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EU EMU BCA conversion prompt control')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - EMU Module                                          */
/*                                                                   */
/*       CL/EUC0010 - Midas EMU BCA Conversion Prompt                */
/*                                                                   */
/*       Function:    This prompt control program will be            */
/*       (I/C)        selected off an input cycle menu option        */
/*                    (Under 'System maintenance' menu), when        */
/*                    the base currency for accounting conversion    */
/*                    is required to take place in the following COB.*/
/*                                                                   */
/*       Calls :   EU0010 - EMU BCA Conversion Prompt                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 137485             Date 25Jun998             */
/*                      CEU001 *C *CREATE  Date 8SEp97               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       137485 - Fix to prevent Database error when going into      */
/*                Mapping Maintenance after exiting from Base        */
/*                Ccy Conversion prompt.                             */
/*       CEU001 - EMU Base Currency For Accounting Conversion        */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,EUC0010INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL      VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
/** Global monitor message */
/**/
             MONMSG   MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                        CMDLBL(ABNOR))
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB   SWS(XXXXXX00)
 
/*********** STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))   /*137485*/
/*********** MONMSGCTL  MSGID(CPF8351)FYOBJ(MNTYF (*FILE))   /*137485*/
 
/*/COPY WNCPYSRC,EUC0010MPS                                          */
 
             CALL     PGM(EU0010)
/**/
/** Database error processing */
/**/
             IF       COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                  TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/*/COPY WNCPYSRC,EUC0010MPE                                          */
 
             GOTO          CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,EUC0010ERR                                          */
 
             SNDPGMMSG     MSG('Transaction failed. Re-input +
                           necessary. Enter to continue.') TOPGMQ(*EXT)
             MONMSG        MSGID(CPF0000 MCH0000)
             ROLLBACK
             MONMSG        MSGID(CPF0000 MCH0000)
             CHGJOB        SWS(XXXXXX11)
             MONMSG        MSGID(CPF0000 MCH0000)
 
/*END:****** ENDCMTCTL                                       /*137485*/
/*********** MONMSG     MSGID(CPF8350)                       /*137485*/
 END:                                                        /*137485*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,EUC0010END                                          */
 
             ENDPGM
