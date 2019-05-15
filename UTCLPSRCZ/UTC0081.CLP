/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT CVTSRCLEN main program')                     */
/*OVR    OVRDBF CVDSPFD QAFDPHY                                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0081 - Processing for CVTSRCLEN                          */
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
/*       Prev Amend No. CUP001 *CREATE     Date 21Dec98              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SRCFIL &SRCLIB &LENDEC &NEWLIB &ERR)
 
             DCL        VAR(&SRCFIL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEWLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LENDEC) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&ERR) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&IN01) TYPE(*LGL)
 
             DCL        VAR(&STRING) TYPE(*CHAR) LEN(50)
             DCL        VAR(&RPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LENGTH) TYPE(*CHAR) LEN(3)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&ALL) TYPE(*CHAR) LEN(1) VALUE('N') /* +
                          srcfil = *ALL indicator */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(CVDSPFD) /* dspfd of old source +
                          file */
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Convert length from decimal to character */
             CHGVAR     VAR(&LENGTH) VALUE(&LENDEC)
 
/* Check if source file is equal to *ALL */
             IF         COND(&SRCFIL *EQ '*ALL') THEN(CHGVAR VAR(&ALL) +
                          VALUE('Y'))
 LOOP:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
/* For source file = *ALL */
             IF         COND(&ALL *EQ 'Y') THEN(DO)
/* Check it is a source file; if not read next file name */
                IF         COND(&PHDTAT *NE 'S') THEN(GOTO +
                          CMDLBL(LOOP))
/* Change source file name */
                CHGVAR     VAR(&SRCFIL) VALUE(&PHFILE)
             ENDDO
 
 
/* For source file not equal *ALL */
             IF         COND(&ALL *NE 'Y') THEN(DO)
/* Check it is a source file; if not then error */
                IF       COND((&PHDTAT *NE 'S') *AND (&ALL *NE 'Y')) +
                          THEN(DO)
                   SNDPGMMSG  MSG('The file is not a source file') +
                          MSGTYPE(*DIAG)
                   CHGVAR     VAR(&ERR) VALUE('Y')
                   GOTO END
                ENDDO
             ENDDO
 
/* If new length less than old length send warning message */
             IF         COND(&LENDEC *LT &PHMXRL) THEN(DO)
               SNDUSRMSG MSG('New length of ' *BCAT &SRCFIL *BCAT 'is +
                          shorter than old. See message help for +
                          reply value: Enter I to ignore this file, +
                          G to process it or C to cancel.') +
                          VALUES(I G C) DFT(I) MSGTYPE(*INQ) +
                          MSGRPY(&RPLY)
                IF         COND(&RPLY = 'C') THEN(GOTO CMDLBL(END))
                IF         COND(&RPLY = 'I') THEN(GOTO CMDLBL(LOOP))
             ENDDO
 
/* Retrieve text */
             RTVOBJD    OBJ(&SRCLIB/&SRCFIL) OBJTYPE(*FILE) +
                          TEXT(&TEXT)
 
/* For new library same as source library: */
             IF         COND((&NEWLIB *EQ '*SRCLIB') *OR (&NEWLIB *EQ +
                          &SRCLIB)) THEN(DO)
                DLTF &SRCLIB/NEWFILE
                MONMSG     MSGID(CPF2105)
                RNMOBJ     OBJ(&SRCLIB/&SRCFIL) OBJTYPE(*FILE) +
                          NEWOBJ(NEWFILE)
                CRTSRCPF   FILE(&SRCLIB/&SRCFIL) RCDLEN(&LENGTH) +
                          TEXT(&TEXT)
                CPYSRCF    FROMFILE(&SRCLIB/NEWFILE) +
                          TOFILE(&SRCLIB/&SRCFIL) FROMMBR(*ALL)
/* Ignore if empty of members */
                MONMSG     MSGID(CPF2868 CPF2817)
                GOTO LOOP
             ENDDO
 
/* For new library different from source library: */
             IF         COND((&NEWLIB *NE '*SRCLIB') *AND (&NEWLIB +
                          *NE &SRCLIB)) THEN(DO)
/* Delete the file if it already exists */
                DLTF       FILE(&NEWLIB/&SRCFIL)
                MONMSG     MSGID(CPF2105)
                CRTSRCPF   FILE(&NEWLIB/&SRCFIL) RCDLEN(&LENGTH) +
                          TEXT(&TEXT)
                CPYSRCF    FROMFILE(&SRCLIB/&SRCFIL) +
                          TOFILE(&NEWLIB/&SRCFIL) FROMMBR(*ALL)
/* Ignore if empty of members */
                MONMSG     MSGID(CPF2868 CPF2817)
                GOTO LOOP
             ENDDO
 
             GOTO END
ABNOR:
/* Receive diagnostic error message */
             RCVMSG     MSGTYPE(*DIAG) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) SNDMSGFLIB(&MSGFLIB)
 
             IF         COND(&MSGID *NE ' ') THEN(DO)
/* Pass it back to calling program */
                SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
                GOTO       CMDLBL(ABNOR)
             ENDDO
/* Receive escape error message */
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) SNDMSGFLIB(&MSGFLIB)
/* Pass it back to calling program */
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
 
END:         DLTF       FILE(&SRCLIB/NEWFILE)
             MONMSG     MSGID(CPF2105)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
