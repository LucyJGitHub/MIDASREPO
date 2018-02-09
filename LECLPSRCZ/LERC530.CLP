/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EOY Processing - Accounts/Deals')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                     */
/*                                                                   */
/*       LERC530 - EOY profitability reset program - DEALS & RETAIL  */
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
/*       085585 - Remove clearing of PEFF123, PEFL123, PERE123,      */
/*                PEGL123, PEDF123.                                  */
/*                                                                   */
/*********************************************************************/
 
PGM
 
             DCL VAR(&LERSTS) TYPE(*CHAR) LEN(128)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF FILE(SDBANKPD)
 
     RTVDTAARA DTAARA(LERSTS) RTNVAR(&LERSTS)
     RCVF RCDFMT(SDBANKD0)
 
     IF COND((&BJRDNB *EQ &BJEYD) *OR ((&BJEYD *GT +
     &BJRDNB) *AND (&BJEYD *LT &BJDNWD)) +
     *OR (%SST(&LERSTS 18 1) *EQ Y)) THEN(DO)
 
     SNDPGMMSG  MSG('Fees, Retail, GL etc  End of Year Processing') +
                                       TOMSGQ(MRUNQ)
/************CLRPFM PEFF123 */                                        /*085585*/
/************CLRPFM PEFL123 */                                        /*085585*/
/************CLRPFM PERE123 */                                        /*085585*/
/************CLRPFM PEGL123 */                                        /*085585*/
/************CLRPFM PEDF123 */                                        /*085585*/
             CLRPFM NPERED
             CLRPFM NPEREZ
 
             CALL   LER530
 
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                 IF     %SWITCH(XXXXXXX1) +
                  SNDPGMMSG  MSG('JOB TERMINATED-DATABASE IN ERROR') +
                              TOMSGQ(MOPERQ MRUNQ)
               ELSE       CMD(SNDPGMMSG MSG('JOB TERMINATED-FILES OUT +
                          OF BALANCE') TOMSGQ(MOPERQ MRUNQ))
                 ENDDO
             ELSE +
                 DO
                     CLRPFM     FILE(LEPEFFD)
                     CLRPFM     FILE(LEPEFLD)
  CPYF       FROMFILE(NPERED) TOFILE(LEPERED) MBROPT(*REPLACE)
  MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LEPERED))
  CPYF       FROMFILE(NPEREZ) TOFILE(LEPEREZ) +
                          MBROPT(*REPLACE) FMTOPT(*NOCHK)
  MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(LEPEREZ))
 
                     CLRPFM     FILE(LEPEGLD)
                     CLRPFM     FILE(LEPEDFD)
 
                 ENDDO
           ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
  ENDPGM
