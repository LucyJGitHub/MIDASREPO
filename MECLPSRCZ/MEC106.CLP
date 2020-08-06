/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SWIFT accounts file reorg')                     */
/********************************************************************/
/*                                                                  */
/*       Midas     - MESSAGE MANAGEMENT                             */
/*                                                                  */
/*       MEC106     S.W.I.F.T. Accounts File Reorganise             */
/*                                                                  */
/*      (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. ERZ212            Date 22Feb13              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                       00000            DATE 00XXX00              */
/*                       00000            DATE 00XXX00              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       ERZ212 - Multicash MT940 Interface                         */
/*                Used /COPYS: MEC106001, MEC106003, MEC106004,     */
/*                             MEC106005                            */
/*       MD046248 - Finastra Rebranding                             */
/*                                                                  */
/********************************************************************/
             PGM     PARM(&CNAM &CSEQ)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL     VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL     VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL     VAR(&BUSY) TYPE(*CHAR) LEN(1)
/**/
             DCL        VAR(&LDA)    TYPE(*CHAR) LEN(256)
/*/COPY WNCPYSRC,MEC106004                                           */
/**/
             CHGJOB     SWS(00000000)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/*/COPY WNCPYSRC,MEC106005                                           */
/**/
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
/**/
             IF         COND(&BUSY = 'N') THEN(DO)
/**/
                SNDPGMMSG  MSG('S.W.I.F.T. Accounts File Reorganise') +
                             TOMSGQ(MRUNQ)
/**/
                CLRPFM     FILE(SWACNSA)
                CLRPFM     FILE(SWACNSB)
                CLRPFM     FILE(SWACNSC)
/**/
/*/COPY WNCPYSRC,MEC106001                                           */
                CALL       PGM(ME0040)
/**/
                IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
                   CHGVAR    VAR(&BUSY) VALUE('Y')
                   CALL      CB0150 PARM(&CNAM &CSEQ &BUSY)
/**/
                ENDDO
/**/
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
                CHGVAR    VAR(&BUSY) VALUE(' ')
                CALL      CB0160 PARM(&CNAM &CSEQ &BUSY)
/**/
                IF         COND(&BUSY = 'Y') THEN(DO)
/**/
                   CLRPFM     FILE(SWACSSA)
                   CLRPFM     FILE(SWACSSB)
                   CLRPFM     FILE(SWACSSC)
/*/COPY WNCPYSRC,MEC106002                                           */
/**/
                   CPYF       FROMFILE(SWACNSA) TOFILE(SWACSSA) +
                                MBROPT(*ADD) FMTOPT(*NOCHK)
/**/
                   CPYF       FROMFILE(SWACNSB) TOFILE(SWACSSB) +
                                MBROPT(*ADD) FMTOPT(*NOCHK)
                   MONMSG     MSGID(CPF2817)
/**/
                   CPYF       FROMFILE(SWACNSC) TOFILE(SWACSSC) +
                                MBROPT(*ADD) FMTOPT(*NOCHK)
/**/
                   CLRPFM     FILE(SWACNSA)
                   CLRPFM     FILE(SWACNSB)
                   CLRPFM     FILE(SWACNSC)
/*/COPY WNCPYSRC,MEC106003                                           */
/**/
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
/**/
                ENDDO
/**/
             ENDDO
/**/
             ELSE       CMD(DO)
/**/
                IF         COND(%SWITCH(XXXXXX10)) THEN(DO)
                   SNDPGMMSG  MSG('FILE CONTROLS OUT OF BALANCE') +
                                 TOMSGQ(MRUNQ MOPERQ)
                   CHGJOB     SWS(XXXXXX01)
                ENDDO
                ELSE       CMD(DO)
/**/
                   RTVDTAARA  DTAARA(LDA)    RTNVAR(&LDA)
                 CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
/**/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOMSGQ(MRUNQ MOPERQ)
/**/
                ENDDO
/**/
             ENDDO
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
