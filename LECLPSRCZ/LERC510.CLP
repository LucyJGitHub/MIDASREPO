/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EOY Processing - Facility Extract')             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                     */
/*                                                                   */
/*       LERC510 - EOY profitability reset program - FACILITY        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 085585             DATE 05APR95              */
/*       PREV AMEND NO. XXXXXX             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       085585 - Remove clearing of PEFC123.                        */
/*                                                                   */
/*********************************************************************/
 
PGM
 
             DCLF FILE(SDBANKPD)
             DCL        VAR(&LERSTS)  TYPE(*CHAR) LEN(128)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
     RTVDTAARA  DTAARA(LERSTS) RTNVAR(&LERSTS)
     RCVF RCDFMT(SDBANKD0)
     IF COND((&BJRDNB *EQ &BJEYD) *OR ((&BJEYD *GT +
     &BJRDNB) *AND (&BJEYD *LT &BJDNWD)) +
     *OR (%SST(&LERSTS 18 1) *EQ Y)) THEN(DO)
 
             CLRPFM NPEFCD
             CLRPFM NPEFCZ
/************CLRPFM PEFC123 */                                        /*085585*/
     SNDPGMMSG  MSG('Facility Profitability End of Year Processing') +
                                       TOMSGQ(MRUNQ)
             CALL   LER510
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                 IF     %SWITCH(XXXXXXX1) +
                  SNDPGMMSG  MSG('JOB TERMINATED-DATABASE IN ERROR') +
                              TOMSGQ(MOPERQ MRUNQ)
               ELSE       CMD(SNDPGMMSG MSG('JOB TERMINATED-FILES OUT +
                          OF BALANCE') TOMSGQ(MOPERQ MRUNQ))
                 ENDDO
             ELSE CMD(DO)
     CPYF       FROMFILE(NPEFCD) TOFILE(LEPEFCD) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LEPEFCD))
     CPYF       FROMFILE(NPEFCZ) TOFILE(LEPEFCZ) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LEPEFCZ))
             CLRPFM     FILE(NPEFCD)
             CLRPFM     FILE(NPEFCZ)
                 ENDDO
 
     ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
