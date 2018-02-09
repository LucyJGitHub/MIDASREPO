/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Transfer between data areas *LDA/*GDA')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC360A - TRANSFER DATA BETWEEN DTAARA'S *GDA/*LDA          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. 179573             Date 12Jun00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      153379             Date 15Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      094431             DATE 16OCT95              */
/*                      S01408             DATE 09JUN95              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       179573 - LDA and GDA are wrong way round in RTVDTAARA and   */
/*                CHGDTAARA command.                                 */
/*       153379 - The RECJOB group session SETANTPGM is SFC0600      */
/*                (the manual instruction) rather than the session   */
/*                manager SETATNPGM SFC4460, so RECJOB group jobs    */
/*                are not open to session manager due to limitation  */
/*                problems. (Fix 122745.)                            */
/*       094431 - Manual adjustment details are not being passed.    */
/*                Positions 450-459 must be omitted for &GRPJOBNAM.  */
/*       S01408 - Addition of core hooks REC360AMPS                  */
/*                Addition of core hooks REC360AMP1                  */
/*                Addition of core hooks REC360AMP2                  */
/*       S01413 - Retail 3 Incorporation                             */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&ACTION)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(1)
/************DCL********VAR(&XFER)   TYPE(*CHAR) LEN(76)*************** 094431*/
/************DCL        VAR(&XFER)   TYPE(*CHAR) LEN(449)        094431 153379*/
             DCL        VAR(&XFER)   TYPE(*CHAR) LEN(283)             /*153379*/
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC360AMPS                                          */
                                                                      /*S01408*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
 
/**/
/**     If parametr = 'O'    Send *LDA out to *GDA                   */
/**/
 
             IF         COND(&ACTION *EQ 'O') THEN(DO)
/******************RTVDTAARA  DTAARA(*LDA (1 76)) RTNVAR(&XFER) ******* 094431*/
/******************CHGDTAARA  DTAARA(*GDA (1 76)) VALUE(&XFER)  ******* 094431*/
/******************RTVDTAARA  DTAARA(*LDA (1 449)) RTNVAR(&XFER) 094431 153379*/
/******************CHGDTAARA  DTAARA(*GDA (1 449)) VALUE(&XFER)  094431 153379*/
                   RTVDTAARA  DTAARA(*LDA (1 283)) RTNVAR(&XFER)      /*153379*/
                   CHGDTAARA  DTAARA(*GDA (1 283)) VALUE(&XFER)       /*153379*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC360AMP1                                          */
                                                                      /*S01408*/
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   CHGDTAARA  DTAARA(*GDA (134 50)) VALUE(&MEM)
                   RETURN
             ENDDO
 
/**/
/**     If parametr = 'I'    Bring *LDA in from *GDA                 */
/**/
 
             IF         COND(&ACTION *EQ 'I') THEN(DO)
/******************RTVDTAARA  DTAARA(*GDA (1 76)) RTNVAR(&XFER) ******* 094431*/
/******************CHGDTAARA  DTAARA(*LDA (1 76)) VALUE(&XFER)  ******* 094431*/
/******************RTVDTAARA  DTAARA(*GDA (1 449)) RTNVAR(&XFER) 094431 153379*/
/******************CHGDTAARA  DTAARA(*LDA (1 449)) VALUE(&XFER)  094431 153379*/
/******************RTVDTAARA  DTAARA(*LDA (1 283)) RTNVAR(&XFER) 153379 179573*/
/******************CHGDTAARA  DTAARA(*GDA (1 283)) VALUE(&XFER)  153379 179573*/
                   RTVDTAARA  DTAARA(*GDA (1 283)) RTNVAR(&XFER)      /*179573*/
                   CHGDTAARA  DTAARA(*LDA (1 283)) VALUE(&XFER)       /*179573*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC360AMP2                                          */
                                                                      /*S01408*/
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
                          program REC360A') TOPGMQ(*PRV) +
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
