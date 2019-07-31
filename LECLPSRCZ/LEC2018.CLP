/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Start Loan Manager i/f (return to i/c)')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC2018 - Lending PC Interface Control                      */
/*                                                                   */
/*       Function: To submit the Lending PC Interface jobs during a  */
/*                 return to input cycle                             */
/*                                                                   */
/*       Calls:    LEC2010                                           */
/*                 LEC2012                                           */
/*                 LEC2017                                           */
/*                 AOBRCHR0                                          */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 225286             Date 17Mar04              */
/*                      216737             Date 08Apr03              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      203561 *CREATE     Date 21Jun02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*  225286 - Ensure REST message is not sent if current status of    */
/*           Loan manager is CLOSED or RESTRICTED. Use new COBREOPEN */
/*           flag on LMxxx data area tocontrol this                  */
/*       216737 - Do not send 'ROPN' message if LEC2011 has not yet  */
/*                run i.e. if position 5 of LMxxx is still an 'N'    */
/*       203561 - Send status messages via new program LEC2017 to    */
/*                control changes of status within Loan Manager.     */
/*                Enable stopping and starting of interface jobs by  */
/*                branch using LMxxx data area (new).                */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&SERV) TYPE(*CHAR) LEN(3) VALUE(' ')
             DCL        VAR(&BRCD) TYPE(*CHAR) LEN(3) VALUE(' ')
             DCL        VAR(&DTAARA) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&LMDTAARA) TYPE(*CHAR) LEN(5) VALUE(' ')
             DCL        VAR(&DISABLED) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&LMSTATUS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OWNER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PHASE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JSEQNO) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&W#LEJNSQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&#BRCD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&P#RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
/* Global Monitor Message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('LEC2018 - Start Customer Lending PC +
                          Interface - Return to I/C') TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(00000000)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB')
 
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&PHASE)
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')
             CHGVAR     VAR(&FMT) VALUE(*BLANKS)
 
 LOOP:
 
/* Access PF/SDBRCHPD to retrieve MQ names */
 
             CALL       PGM(AOBRCHR0) PARM(&RTCD &OPTN &#BRCD &FMT)
 
             CHGVAR     VAR(&OPTN) VALUE('*NEXT')
 
/* Database error handling. */
 
             IF         COND(&RTCD *NE '       ') THEN(DO)
                IF         COND(&RTCD *EQ '*EOF') THEN(GOTO CMDLBL(END))
                CHGVAR     VAR(&MSG) VALUE('Error on access to ICD  +
                             file SDBRCHPD')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CHGVAR     VAR(&SERV) VALUE(%SST(&FMT 184 3))
 
             CHGVAR     VAR(&BRCD) VALUE(%SST(&FMT 1 3))
 
/* Only process live Loan Manager branches */
 
             IF         COND(&SERV *EQ ' ') THEN(GOTO CMDLBL(LOOP))
             CHGVAR     VAR(&DTAARA) VALUE('LEC2010' *CAT +
                          &SERV)
             CHGVAR     VAR(&LMDTAARA) VALUE('LM' *CAT +
                          &SERV)
 
/* Check if LM Server Interface has been disabled */
 
             RTVDTAARA  DTAARA(&LMDTAARA (7 1)) RTNVAR(&DISABLED)
             IF         COND(&DISABLED *EQ 'Y') THEN(GOTO CMDLBL(LOOP))
                                                                                          /*216737*/
/* Check current status of Loan Manager and take action accordingly */                    /*216737*/
                                                                                          /*216737*/
             RTVDTAARA  DTAARA(&LMDTAARA (5 1)) RTNVAR(&LMSTATUS)                         /*216737*/
 
/* Send message to Loan Manager to inform users that I/C is being */
/* re-opened in Midas                                             */
 
             IF         COND(&LMSTATUS *NE 'N') THEN(DO)                                  /*216737*/
             CALL       PGM(LEC2017) PARM(&P#RTCD 'ROPN' &SERV +
                          &BRCD)
             IF         COND(%SWITCH(XXXXXX11) *OR (&P#RTCD *NE +
                          '*SENT')) THEN(GOTO CMDLBL(ABNOR))
 
/* Update LM Branch data area with last message sent */
 
             CHGDTAARA  DTAARA(&LMDTAARA (1 4)) VALUE('ROPN')
             ENDDO                                                                        /*216737*/
 
/**Check*status*of*Loan*Manager*and*take*action*accordingly**/                            /*216737*/
 
/**********  RTVDTAARA  DTAARA(&LMDTAARA (5 1)) RTNVAR(&LMSTATUS) */                      /*216737*/
 
/* Loan Manager in restricted state - download has not yet run */                         /*216737*/
                                                                                          /*216737*/
             IF         COND(&LMSTATUS *EQ 'R') THEN(DO)                                  /*216737*/
                                                                                          /*216737*/
/* Send message to Loan Manager to change status to 'N'ormal */                           /*216737*/
                                                                                          /*216737*/
                CALL       PGM(LEC2017) PARM(&P#RTCD 'OPEN' &SERV &BRCD)                  /*216737*/
                IF         COND(%SWITCH(XXXXXX11) *OR (&P#RTCD *NE +
                             '*SENT')) THEN(GOTO CMDLBL(ABNOR))                           /*216737*/
                                                                                          /*216737*/
/* Update LM Branch data area with last message sent */                                   /*216737*/
                                                                                          /*216737*/
                CHGDTAARA  DTAARA(&LMDTAARA (1 4)) VALUE('OPEN')                          /*216737*/
                                                                                          /*216737*/
/* Update LM Branch data area with new Loan Manager status */                             /*216737*/
                                                                                          /*216737*/
                CHGDTAARA  DTAARA(&LMDTAARA (5 1)) VALUE('N')                             /*216737*/
                CHGVAR  VAR(&LMSTATUS) VALUE('N')                                         /*216737*/
             ENDDO                                                                        /*216737*/
                                                                                          /*216737*/
/* Loan Manager in closed state - download has run so reset status to */                  /*216737*/
/* 'R' so that when Midas COB runs again, download is done again */                       /*216737*/
                                                                                          /*216737*/
             IF         COND(&LMSTATUS *EQ 'C') THEN(DO)                                  /*216737*/
                                                                                          /*216737*/
/* Update LM Branch data area to reset last action to restricted */                       /*216737*/
                                                                                          /*216737*/
                CHGDTAARA  DTAARA(&LMDTAARA (1 4)) VALUE('REST')                          /*216737*/
                                                                                          /*216737*/
/* Update LM Branch data area with new Loan Manager status */                             /*216737*/
                                                                                          /*216737*/
                CHGDTAARA  DTAARA(&LMDTAARA (5 1)) VALUE('R')                             /*216737*/
                CHGVAR  VAR(&LMSTATUS) VALUE('R')                                         /*216737*/
             ENDDO                                                                        /*216737*/
                                                                                          /*216737*/
/**Loan*Manager*in*normal*state*('REST'*message*not*sent)**/                              /*216737*/
/* Only submit input cycle jobs if Loan Manager is now in normal */                       /*216737*/
/* state. If Loan Manager is in a closed state then you do not want */                    /*216737*/
/* to submit the jobs as the rundate in Midas will not match the */                       /*216737*/
/* rundate in Loan Manager */                                                             /*216737*/
 
             IF         COND(&LMSTATUS *EQ 'N') THEN(DO)
 
/* Submit Loan Manager Interface branch job */
 
                CALL       PGM(LEC2010) PARM(&SERV &BRCD)
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(ABNOR))
/* Submit drip feed job */
 
                CALL       PGM(LEC2012)
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(ABNOR))
             ENDDO
 
/**Loan*Manager*in*restricted*state**/                                                    /*216737*/
 
/**********  IF         COND(&LMSTATUS *EQ 'R') THEN(DO) */                               /*216737*/
 
/**Send*message*to*Loan*Manager*to*change*status*to*'N'ormal**/                           /*216737*/
 
/**********     CALL       PGM(LEC2017) PARM(&P#RTCD 'OPEN' &SERV &BRCD) */               /*216737*/
/**********     IF         COND(%SWITCH(XXXXXX11) *OR (&P#RTCD *NE +     */               /*216737*/
/**********                  '*SENT')) THEN(GOTO CMDLBL(ABNOR))          */               /*216737*/
 
/**Update*LM*Branch*data*area*with*last*message*sent**/                                   /*216737*/
 
/**********     CHGDTAARA  DTAARA(&LMDTAARA (1 4)) VALUE('OPEN') */                       /*216737*/
 
/**Update*LM*Branch*data*area*with*new*Loan*Manager*status**/                             /*216737*/
 
/**********     CHGDTAARA  DTAARA(&LMDTAARA (5 1)) VALUE('N') */                          /*216737*/
 
/**Submit*Loan*Manager*Interface*branch*job**/
 
/**********     CALL       PGM(LEC2010) PARM(&SERV &BRCD) */                              /*216737*/
/**********     IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO + */                         /*216737*/
/**********                  CMDLBL(ABNOR)) */                                            /*216737*/
 
/**Submit*drip*feed*job**/
 
/**********     CALL       PGM(LEC2012) */                                                /*216737*/
/**********     IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO + */                         /*216737*/
/**********                  CMDLBL(ABNOR)) */                                            /*216737*/
 
/**********  ENDDO */                                                                     /*216737*/
 
/**Else*Loan*Manager*is*in*closed*state*(download*has*run)**/                             /*216737*/
/**so*don't*submit*the*branch*job*and*leave*status*as*'C'***/                             /*216737*/
/* However, also set the COBREOPEN flag on data area LMxxx */                             /*225286*/
/* so that the re-run of the COB will force another        */                             /*225286*/
/* download                                                */                             /*225286*/
                                                                                          /*225286*/
             CHGDTAARA  DTAARA(&LMDTAARA (11 1)) VALUE('Y')                               /*225286*/
 
             GOTO       CMDLBL(LOOP)
 
/* Abnormal termination */
 ABNOR:
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
                CHGJOB     SWS(XXXXXX11)
                SNDPGMMSG  MSG('LEC2018 - Start Customer Lending PC +
                             Interface - Return to I/C HAS ENDED +
                             ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
                SNDPGMMSG  MSG('LEC2018 - Start Customer Lending PC +
                             Interface - Return to I/C HAS ENDED +
                             ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
/* Call SCC0010 to inform the user that an error has occurred */
 
                RTVMSG     MSGID(SCM0087) MSGF(GBMIDASMSG) MSG(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
                MONMSG     MSGID(CPF0000 MCH0000)
 
                CALL       PGM(SCC0010) PARM('LEC2010' 'ENTER' ' ')
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Normal termination */
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
