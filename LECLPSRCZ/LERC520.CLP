/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EOY Processing - Loans/Margins')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                     */
/*                                                                   */
/*       LERC520 - EOY profitability reset program - LOANS & MARGIN  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 085585             Date 05Apr95              */
/*                      XXXXXX             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       085585 - Remove clearing of PELN123.                        */
/*                                                                   */
/*********************************************************************/
 
PGM
 
             DCLF FILE(SDBANKPD)
             DCL        VAR(&LERSTS)  TYPE(*CHAR) LEN(128)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
     RTVDTAARA  DTAARA(LERSTS) RTNVAR(&LERSTS)
     RCVF RCDFMT(SDBANKD0)
     IF COND((&BJRDNB *EQ &BJEYD) *OR ((&BJEYD *GT +
     &BJRDNB) *AND (&BJEYD *LT &BJDNWD)) +
     *OR (%SST(&LERSTS 18 1) *EQ Y)) THEN(DO)
 
             CLRPFM NPELND
             CLRPFM NPELNZ
             CLRPFM NPEMGD
             CLRPFM NPEMGZ
/************CLRPFM PELN123 */                                        /*085585*/
             SNDPGMMSG  MSG('Loan & Margin Profitability End of Year +
                          Processing') TOMSGQ(MRUNQ)
             CALL   LER520
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                 IF     %SWITCH(XXXXXXX1) +
                  SNDPGMMSG  MSG('JOB TERMINATED-DATABASE IN ERROR') +
                              TOMSGQ(MOPERQ MRUNQ)
               ELSE       CMD(SNDPGMMSG MSG('JOB TERMINATED-FILES OUT +
                          OF BALANCE') TOMSGQ(MOPERQ MRUNQ))
                 ENDDO
             ELSE +
                 DO
     CPYF       FROMFILE(NPELND) TOFILE(LEPELND) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LEPELND))
     CPYF       FROMFILE(NPELNZ) TOFILE(LEPELNZ) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LEPELNZ))
     CPYF       FROMFILE(NPEMGD) TOFILE(LEPEMGD) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LEPEMGD))
     CPYF       FROMFILE(NPEMGZ) TOFILE(LEPEMGZ) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LEPEMGZ))
                     CLRPFM     FILE(NPELND)
                     CLRPFM     FILE(NPELNZ)
                     CLRPFM     FILE(NPEMGD)
                     CLRPFM     FILE(NPEMGZ)
                 ENDDO
 
                 ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
  ENDPGM
