/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Transfer between DTAARA *LDA/*GDA')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - GENERAL LEDGER MODULE                       */
/*                                                                   */
/*       GLC440A -  TRANSFER DATA BETWEEN DTAARA'S *GDA/*LDA         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*           1988,1989                                               */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 060468             Date 21Jan94              */
/*                      S01405             Date 03Dec91              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       060468 - Update data areas with ACMV group job references   */
/*                without overriding other data.                     */
/*       S01405 - Remove group job references.                       */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&ACTION)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1)
/************DCL        VAR(&XFER)   TYPE(*CHAR) LEN(512)        */  /*060468*/
/*/COPY WNCPYSRC,GLC440A001                                          */
             DCL        VAR(&XFER)   TYPE(*CHAR) LEN(51)             /*060468*/
 
/*/COPY WNCPYSRC,GLC440A002                                          */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
/**/
/**     If parametr = 'O'    Send *LDA out to *GDA                   */
/**/
 
             IF         COND(&ACTION *EQ 'O') THEN(DO)
/************      RTVDTAARA  DTAARA(*LDA (1 512)) RTNVAR(&XFER)  */ /*060468*/
/*/COPY WNCPYSRC,GLC440A003                                          */
                   RTVDTAARA  DTAARA(*LDA (2 51))  RTNVAR(&XFER)     /*060468*/
                   CHGDTAARA  DTAARA(*GDA (2 51))  VALUE(&XFER)      /*060468*/
/*/COPY WNCPYSRC,GLC440A004                                          */
/*                 CHGDTAARA  DTAARA(*GDA (1 512)) VALUE(&XFER)         S01405*/
                   RETURN
             ENDDO
 
/**/
/**     If parametr = 'I'    Bring *LDA in from *GDA                 */
/**/
 
             IF         COND(&ACTION *EQ 'I') THEN(DO)
/************      RTVDTAARA  DTAARA(*GDA (1 512)) RTNVAR(&XFER)  */ /*060468*/
/*/COPY WNCPYSRC,GLC440A005                                          */
                   RTVDTAARA  DTAARA(*GDA (2 51))  RTNVAR(&XFER)     /*060468*/
                   CHGDTAARA  DTAARA(*LDA (2 51))  VALUE(&XFER)      /*060468*/
/*/COPY WNCPYSRC,GLC440A006                                          */
/*                 CHGDTAARA  DTAARA(*LDA (1 512)) VALUE(&XFER)         S01405*/
                   RETURN
             ENDDO
 
 
/*************************************************************/
/**           This point in the program is reached if the    */
/**           wrong parameter was sent to the program. So    */
/**           send a cancelation message to the enquiry.     */
/*************************************************************/
 
             CHGJOB     SWS(1XXXXXXX)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGDTA('Incorrect parameter passed to +
                          program GLC440A') TOPGMQ(*PRV) +
                          MSGTYPE(*ESCAPE)
             RETURN
 
/*************************************************************/
/**  ABNORMAL processing will only occur if the group job    */
/**           session has not been setup.  Send a message    */
/**           to he user but allow the enquiry program  to   */
/**           continue                                       */
/*************************************************************/
 
 
ABNOR:       SNDUSRMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Group +
                          Job session not active - data area *GDA is +
                          not available') TOMSGQ(*EXT) MSGTYPE(*INFO)
 
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
