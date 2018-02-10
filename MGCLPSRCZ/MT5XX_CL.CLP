/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MT5xx : To switch on feature S01401')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                       */
/*                                                                   */
/*       MT5XX_CL - MT5xx Database Upgrade - Controlling CL.         */
/*                                                                   */
/*       Purpose : To be called whenever a Client switches on the    */
/*                 SWIFT MT5xx SE Message Generation Switchable      */
/*                 Feature : S01401.                                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      103428             Date 20May96              */
/*                      085991             DATE 13APR95              */
/*                      S01401             DATE 11MAY93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       103428 - Run initialisation from SCOFMENU                   */
/*       085991 - Generate POSETDX2 file                             */
/*       S01401 - Database Upgrade for SWIFT Messages MT5xxs         */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
     /*******PGM                                                        103428*/
             PGM        PARM(&RTNCDE &IPMODE)                         /*103428*/
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)               /*103428*/
             DCL        VAR(&IPMODE) TYPE(*CHAR) LEN(1)               /*103428*/
                                                                      /*103428*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERROR2))
 
             CHGJOB     LOG(4 00 *SECLVL) LOGCLPGM(*YES)
 
             CHGJOB     SWS(XXXXXX00)
/**/
/* */                                                                 /*103428*/
/** Mode 1 - Calling program for the first time                    */ /*103428*/
/** Mode 2 - Re-calling program if already previously used         */ /*103428*/
/* */                                                                 /*103428*/
             IF         COND((&IPMODE *EQ '1') *OR +
                          (&IPMODE *EQ '2')) THEN(DO)                 /*103428*/
                                                                      /*103428*/
                    CLRPFM TRADSDX1                                   /*103428*/
                    CLRPFM BULKSDX1                                   /*103428*/
                    CLRPFM DPTMVDX1                                   /*103428*/
                                                                      /*103428*/
/** Set default records for BULKSDX1 & TRADSDX1 as per TRADSD file   */
/**/
             CALL       PGM(BLK_TRDUPG)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR1))
/**/
/** Ensure Depot Movements are unique across ALL Securities then     */
/** set default records for DPTMVDX1 as per records on DPTMVD file   */
/**/
             OVRDBF     FILE(DPTMVX) TOFILE(DPTMVDL1) SHARE(*NO)
             CALL       PGM(DPTMVDU)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR1))
             DLTOVR     FILE(*ALL)
/**/
             CALL       PGM(DPTMVDX1)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR1))
/**/
/** Set default records for POSETDX1 as per records on POSETD file   */
/**/
             CLRPFM     FILE(POSETDX1)                                /*085991*/
             MONMSG     MSGID(CPF0000)                                /*085991*/
             CALL       PGM(POSETDX1)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR1))
/**/                                                                  /*085991*/
/** Set default records for POSETDX2 as per records on POSETD file */ /*085991*/
/**/                                                                  /*085991*/
             CLRPFM     FILE(POSETDX2)                                /*085991*/
             MONMSG     MSGID(CPF0000)                                /*085991*/
             CALL       PGM(POSETDX2)                                 /*085991*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR1))                             /*085991*/
 
/**/
/** Set default records for SDCUSTXA as per records on SDCUSTPD file */
/**/
             CALL       PGM(SDCUSTXA)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR1))
/**/
/** Set default field - OWOT - on SECGTD                             */
/**/
             CALL       PGM(SECGTDX1)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR1))
/**/
/** Set default fields - SWTP & ISIN - on SECTYD                     */
/**/
             CALL       PGM(SECTYDX1)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR1))
 
ENDDO                                                                 /*103428*/
 
             GOTO       CMDLBL(ENDPGM)
 
             CHGVAR     VAR(&RTNCDE) VALUE('*ERROR')                  /*103428*/
 
 ERROR1:     RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(+
                   &MEM) TOPGMQ(*EXT)
 
 ERROR2:     SNDPGMMSG  MSG('Program MT5XX_CL ENDED ABNORMALLY See +
                          job log for more information') TOPGMQ(*EXT)
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
