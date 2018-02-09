/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GP Generate key data')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GPC0012 - Generate Key Data                                 */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1093817          Date 05Mar13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CGP001  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1093817 - Dumps are produced when switching on/off        */
/*                   features.                                       */
/*       CGP001 - Global Processing                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ZONE &GFGPF &GFGLFU)
 
             DCL        VAR(&ZONE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GFGPF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GFGLFU) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB SWS(00000000)
 
             DSPFD      FILE(&GFGLFU) TYPE(*ACCPTH) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/GPFDA)
 
             DSPFFD     FILE(&GFGLFU) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/GPFFD)
 
             OVRDBF     FILE(GPKEYDPD) SHARE(*NO)                                      /*AR1093817*/
             CALL       PGM(GPGENKEYD) PARM(&ZONE &GFGPF)
             DLTOVR     FILE(GPKEYDPD)                                                 /*AR1093817*/
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
