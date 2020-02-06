/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Route user to correct Midas menu')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCAUTOS - Reroute COB processing restart                    */
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
/*       Prev Amend No. 102287             Date 24Apr96              */
/*                      S01408             Date 07Aug95              */
/*                      S01463             Date 18APR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       102287 - LDA does not exist when this pgm is called, so     */
/*                create it                                          */
/*       S01408 - Hooks moved to WNCPYSRC from SCCPYSRC:             */
/*                - SCAUTOSINT                                       */
/*                - SCAUTOSMPS                                       */
/*                - SCAUTOSMPE                                       */
/*                - SCAUTOSERR                                       */
/*                - SCAUTOSEND                                       */
/*       S01463 - This program calls CL program SCC0104. All of      */
/*                the old SCAUTOS processing has been moved to       */
/*                a new program SCC0104                              */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,SCAUTOSINT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area')            /*102287*/
             MONMSG     MSGID(CPF1023)                                /*102287*/
                                                                      /*102287*/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,SCAUTOSMPS                                          */
 
/* Call the COB restart program */
 
             CALL       PGM(SCC0104)
 
/*/COPY WNCPYSRC,SCAUTOSMPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,SCAUTOSERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCAUTOS ended abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,SCAUTOSEND                                          */
 
             ENDPGM
