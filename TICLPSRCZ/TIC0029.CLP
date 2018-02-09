/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas TI Support functions: routine 9')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC0029 - TI Environment Support Functions: Routine 9       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CTI001  *CREATE    Date 03Oct97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       CTI001 - Requirements clarification for Midas/TI Interface  */
/*                Program created.                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MNEM &FLAG)
 
/*/COPY WNCPYSRC,TIC0020INT                                          */
 
             DCL        VAR(&MNEM) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FLAG) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,TIC0020MPS                                          */
 
/*/COPY WNCPYSRC,TIC0020MPE                                          */
 
/* Is input allowed */
 
             CHGVAR     VAR(&FLAG) VALUE('N')
             CHGVAR &DMLIB (%SST(&MNEM 1 2) *TCAT 'DMLIB')
             RTVDTAARA  DTAARA(&DMLIB/MPHAS (1 1)) RTNVAR(&MPHAS)
/**********  IF         COND(&MPHAS *EQ 'A') THEN(DO)                                  */ /*CCB020*/
             IF         COND((&MPHAS *EQ 'A') *OR (&MPHAS *EQ 'G')) +
                          THEN(DO)                                                        /*CCB020*/
               CHGVAR   VAR(&FLAG) VALUE('Y')
             ENDDO
             GOTO END
 
 ABNOR:
/*/COPY WNCPYSRC,TIC0020ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          TIC0029 ended abnormally - see job log')
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,TIC0020END                                          */
 
             ENDPGM
