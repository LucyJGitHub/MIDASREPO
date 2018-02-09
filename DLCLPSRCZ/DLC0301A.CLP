/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL CUSTOMER DEALS ENQUIRY BY DATE')             */
/********************************************************************/
/*                                                                  */
/*        Midas     - Dealing Module                                */
/*                                                                  */
/*       DLC0301A - CUSTOMER DEALS ENQUIRY SORTED IN DESCENDING     */
/*                  DATE ORDER                                      */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG1832            Date 19Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      XXXXXX             Date DDMMMYY              */
/*                      XXXXXX             Date DDMMMYY              */
/*                                                                  */
/********************************************************************/
/*       MD046248 - Finastra Rebranding                             */
/*       BUG1832- Projected Account Movements Enquiry Problems      */
/*       PROGRAM CREATED TO DISPLAY THE ENQUIRY IN DESCENDING DATE  */
/*       ORDER                                                      */
/*       THIS PROGRAM WAS CREATED TO FIX E26937                     */
/********************************************************************/
/*/COPY WNCPYSRC,DLC0301A01                                          */
             PGM
/*/COPY WNCPYSRC,DLC0301A02                                          */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
/*/COPY WNCPYSRC,DLC0301A03                                          */
/**/
             DLTDTAARA  DTAARA(DLSDS)
             MONMSG     MSGID(CPF0000)
/**********  CRTDTAARA  DTAARA(QTEMP/DLSDS) TYPE(*CHAR) LEN(161)     */                  /*BUG1832*/
             CRTDTAARA  DTAARA(QTEMP/DLSDS) TYPE(*CHAR) LEN(167)                         /*BUG1832*/
             CHGJOB     SWS(00000000)
/**/
/*/COPY WNCPYSRC,DLC0301A04                                          */
             CALL       PGM(DL0121)
/*/COPY WNCPYSRC,DLC0301A05                                          */
/**/
             RTVJOBA    JOB(&JOB) SWS(&SWS)
             IF         COND((%SUBSTRING(&SWS 7 1) = '1') *OR +
                        (%SUBSTRING(&SWS 8 1) = '1')) THEN(DO)
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                   CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
                   SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
