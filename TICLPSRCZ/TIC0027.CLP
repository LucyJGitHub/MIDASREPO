/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Environment support functions:routines7-8')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC0027 - TI Environment Support Functions: Routines 7-8    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. AR861029           Date 09Sep19              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSC017             Date 14Feb03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CTI001  *CREATE    Date 03Oct97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR861029 - Error in setting up of library list due to its   */
/*                  long length. Increase the size of the variables  */
/*                  involved. (Child: AR861030)                      */
/*                - Applied for MD054158.                            */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC017 - Change to 250 library list.                        */
/*       CTI001 - Requirements clarification for Midas/TI Interface  */
/*                Program created.                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ROUTINE &MNEM)
 
/*/COPY WNCPYSRC,TIC0027INT                                          */
 
             DCL        VAR(&ROUTINE) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&MNEM) TYPE(*CHAR) LEN(3)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)
/************DCL        VAR(&NEWLIBL) TYPE(*CHAR) LEN(275)                             */ /*CSC017*/
/************DCL        &CHGLIBL *CHAR 289                                             */ /*CSC017*/
/************DCL        &CMDLEN *DEC (15 5) 289                                        */ /*CSC017*/
             DCL        VAR(&NEWLIBL) TYPE(*CHAR) LEN(2750)                               /*CSC017*/
             DCL        VAR(&CHGLIBL) TYPE(*CHAR) LEN(2764)                               /*CSC017*/
             DCL        VAR(&CMDLEN) TYPE(*DEC) LEN(15 5) VALUE(2764)                     /*CSC017*/
             DCL        VAR(&QLFDJOBD) TYPE(*CHAR) LEN(20)
             DCL        VAR(&LEN) TYPE(*CHAR) LEN(4)
/**********  DCL        VAR(&PARM) TYPE(*CHAR) LEN(1000)             */                 /*AR861029*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(9999)                                /*AR861029*/
             DCL        VAR(&ERRCDE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&OFFSET) TYPE(*DEC) LEN(9 0)
             DCL        VAR(&LIBCNT) TYPE(*DEC) LEN(9 0)
             DCL        VAR(&OFFLEN) TYPE(*DEC) LEN(9 0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     LOG(4 00 *SECLVL) LOGCLPGM(*YES)                                /*AR861029*/
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,TIC0027MPS                                          */
 
/*/COPY WNCPYSRC,TIC0027MPE                                          */
 
 
             IF         COND(&ROUTINE *EQ 7) THEN(DO)
               GOTO     CMDLBL(ROUTINE07)
             ENDDO
 
             IF         COND(&ROUTINE *EQ 8) THEN(DO)
               GOTO     CMDLBL(ROUTINE08)
             ENDDO
 
 
/* Otherwise routine passed as paramter is invalid */
 
             GOTO       CMDLBL(ABNOR)
 
 
 ROUTINE07:
 
/* Initialise processing unit */
 
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256))
 
/* First set the current library list to that in the TIJOBD        */
/* jod description                                                 */
 
             CHGVAR     VAR(&PREFIX) VALUE(%SST(&MNEM 1 2))
             CHGVAR     VAR(&XLIB) VALUE(&PREFIX *TCAT 'XLIB')
             CHGVAR     VAR(&QLFDJOBD) VALUE('TIJOBD    ' *CAT &XLIB)
/**********  CHGVAR     VAR(%BIN(&LEN 1 4)) VALUE(1000)              */                 /*AR861029*/
             CHGVAR     VAR(%BIN(&LEN 1 4)) VALUE(9999)                                 /*AR861029*/
             CHGVAR     VAR(%BIN(&ERRCDE 1 4)) VALUE(0)
             CALL       PGM(QWDRJOBD) PARM(&PARM &LEN JOBD0100 +
                          &QLFDJOBD &ERRCDE)
             CHGVAR     VAR(&OFFSET) VALUE(%BIN(&PARM 361 4))
             CHGVAR     VAR(&OFFSET) VALUE(&OFFSET + 1)
             CHGVAR     VAR(&LIBCNT) VALUE(%BIN(&PARM 365 4))
             CHGVAR     VAR(&OFFLEN) VALUE(11 * &LIBCNT)
             CHGVAR     VAR(&NEWLIBL) VALUE(%SST(&PARM &OFFSET +
                          &OFFLEN))
             MONMSG     MSGID(MCH3601)
             CHGVAR     VAR(&CHGLIBL) VALUE('CHGLIBL LIBL(' *TCAT +
                          &NEWLIBL *TCAT ')')
             CALL QCMDEXC (&CHGLIBL &CMDLEN)
 
/*   Start commitment control  */
 
             CHGVAR     VAR(&JLIB) VALUE(&PREFIX *TCAT 'JLIB')
 
             GOTO       CMDLBL(END)
 
 ROUTINE08:
 
/* Return the current processing mnemonic */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&MNEM) VALUE(&PREFIX *CAT '1')
             GOTO       CMDLBL(END)
 
 
 ABNOR:
/*/COPY WNCPYSRC,TIC0027ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          TIC0027 ended abnormally - see job log')
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,TIC0027END                                          */
 
             ENDPGM
