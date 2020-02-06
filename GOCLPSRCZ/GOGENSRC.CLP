/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Generate source')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOGENSRC - Generate Source                                  */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 02Jun08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG10215           Date 27Sep06              */
/*                      CGP001  *CREATE    Date 23May03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Replace non-standard codes.                       */
/*       BUG10215 - Global replication needs a global interface      */
/*                  to facilitate independent zone upgrades          */
/*                  GENERATED SOURCE IS NOW PUT TO SRCFS IN QTEMP:   */
/*                  GOGENSRCZ.                                       */
/*                  GPCPYSRCG.                                       */
/*                  GPGENSRCG.                                       */
/*       CGP001 - Global Processing                                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(3 0) VALUE(0)
             DCL        VAR(&FIRST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&GORPG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GPRPG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GPCPY) TYPE(*CHAR) LEN(10)
 
             DCLF       FILE(GPGLOBFPD)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             DLTF       FILE(QTEMP/GORPGG)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/GPRPGG)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/GPCPYG)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/GPCPYWHG)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/GPCPYSRG)
             MONMSG     MSGID(CPF0000)
                                                                                        /*BUG10215*/
             DLTF       FILE(QTEMP/GOGENSRCZ.)                                          /*BUG10215*/
             MONMSG     MSGID(CPF0000)                                                  /*BUG10215*/
             DLTF       FILE(QTEMP/GPGENSRCG.)                                          /*BUG10215*/
             MONMSG     MSGID(CPF0000)                                                  /*BUG10215*/
             DLTF       FILE(QTEMP/GPCPYSRCG.)                                          /*BUG10215*/
             MONMSG     MSGID(CPF0000)                                                  /*BUG10215*/
 
             CRTSRCPF   FILE(QTEMP/GORPGG) RCDLEN(112)
             CRTSRCPF   FILE(QTEMP/GPRPGG) RCDLEN(112)
             CRTSRCPF   FILE(QTEMP/GPCPYG) RCDLEN(112)
             CRTSRCPF   FILE(QTEMP/GPCPYWHG) RCDLEN(112)
             CRTSRCPF   FILE(QTEMP/GPCPYSRG) RCDLEN(112)
             CRTSRCPF   FILE(QTEMP/GOGENSRCZ.) RCDLEN(112)                              /*BUG10215*/
             CRTSRCPF   FILE(QTEMP/GPGENSRCG.) RCDLEN(112)                              /*BUG10215*/
             CRTSRCPF   FILE(QTEMP/GPCPYSRCG.) RCDLEN(112)                              /*BUG10215*/
 
             ADDPFM     FILE(QTEMP/GORPGG) MBR(GORPGG) +
                          TEXT('Generated Code') SRCTYPE(RPGLE)
             ADDPFM     FILE(QTEMP/GPRPGG) MBR(GPRPGG) +
                          TEXT('Generated Code') SRCTYPE(RPGLE)
             ADDPFM     FILE(QTEMP/GPCPYG) MBR(GPCPYG) +
                          TEXT('Generated Code') SRCTYPE(RPGLE)
             ADDPFM     FILE(QTEMP/GPCPYWHG) MBR(GPCPYWHG) +
                          TEXT('Generated Code') SRCTYPE(RPGLE)
             ADDPFM     FILE(QTEMP/GPCPYSRG) MBR(GPCPYSRG) +
                          TEXT('Generated Code') SRCTYPE(RPGLE)
 
             OVRDBF     FILE(GORPGG) TOFILE(QTEMP/GORPGG)
             OVRDBF     FILE(GPRPGG) TOFILE(QTEMP/GPRPGG)
             OVRDBF     FILE(GPCPYG) TOFILE(QTEMP/GPCPYG)
             OVRDBF     FILE(GPCPYWHG) TOFILE(QTEMP/GPCPYWHG)
             OVRDBF     FILE(GPCPYSRG) TOFILE(QTEMP/GPCPYSRG)
 
/************RMVM       FILE(GPCPYSRCG) MBR(GPZOLSYNWH)    **************************/  /*BUG10215*/
/************MONMSG     MSGID(CPF0000)                     **************************/  /*BUG10215*/
/************RMVM       FILE(GPCPYSRCG) MBR(GPZOLSYNSR)    **************************/  /*BUG10215*/
/************MONMSG     MSGID(CPF0000)                     **************************/  /*BUG10215*/
LOOP:        RCVF
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
             IF         COND(&COUNT = 1) THEN(CHGVAR VAR(&FIRST) +
                          VALUE('Y'))
             IF         COND(&COUNT > 1) THEN(CHGVAR VAR(&FIRST) +
                          VALUE('N'))
             CLRPFM     FILE(GORPGG)
             CLRPFM     FILE(GPRPGG)
             CLRPFM     FILE(GPCPYG)
             CLRPFM     FILE(GPCPYWHG)
             CLRPFM     FILE(GPCPYSRG)
             CALL       PGM(GOZGENSRC) PARM(&GFZPF &GFZLF &FIRST +
                          &GORPG &GPRPG &GPCPY)
 
/* Bulk Synchronisation*/
             IF         COND(&GFBLSY = 'Y') THEN(DO)
             CPYF       FROMFILE(GORPGG) TOFILE(GOGENSRCZ.) +
                        TOMBR(&GORPG)  MBROPT(*REPLACE)                                 /*BUG10215*/
/************CPYF       FROMFILE(GORPGG) +                     ***********************/ /*BUG10215*/
/************             TOFILE(GORPGSRCG) TOMBR(&GORPG) +    ***********************/ /*BUG10215*/
/************             MBROPT(*REPLACE)                     ***********************/ /*BUG10215*/
             ENDDO
 
/* On-line Synchronisation*/
/************IF         COND(&GFOLSY = 'T' *OR &GFOLSY = 'B') THEN(DO)   *************/ /*BUG10215*/
             IF         COND(&GFOLSY ='T' *OR &GFOLSY ='B' *OR &GFOLSY ='N') THEN(DO)   /*BUG10215*/
             CPYF       FROMFILE(GPRPGG) TOFILE(GPGENSRCG.)  +
                          TOMBR(&GPRPG)     MBROPT(*REPLACE)                            /*BUG10215*/
             CPYF       FROMFILE(GPCPYG)   TOFILE(GPCPYSRCG.) +
                          TOMBR(&GPCPY)     MBROPT(*REPLACE)                            /*BUG10215*/
/************IF         COND(&GFOLSY**= 'N') THEN(DO)                    */ /*BUG10215*/ /*BG18886*/
             IF         COND(&GFOLSY *NE 'N') THEN(DO)                      /*BUG10215*/ /*BG18886*/
             CPYF       FROMFILE(GPCPYWHG) TOFILE(GPCPYSRCG.) +
                          TOMBR(GPZOLSYNWH) MBROPT(*ADD)                                /*BUG10215*/
             CPYF       FROMFILE(GPCPYSRG) TOFILE(GPCPYSRCG.) +
                          TOMBR(GPZOLSYNSR) MBROPT(*ADD)                                /*BUG10215*/
             ENDDO                                                                      /*BUG10215*/
/************CPYF       FROMFILE(GPRPGG) +                      **********************/ /*BUG10215*/
/************             TOFILE(GPRPGSRCG) TOMBR(&GPRPG) +     **********************/ /*BUG10215*/
/************             MBROPT(*REPLACE)                      **********************/ /*BUG10215*/
/************CPYF       FROMFILE(GPCPYG) +                      **********************/ /*BUG10215*/
/************             TOFILE(GPCPYSRCG) TOMBR(&GPCPY) +     **********************/ /*BUG10215*/
/************             MBROPT(*REPLACE)                      **********************/ /*BUG10215*/
/************CPYF       FROMFILE(GPCPYWHG) TOFILE(GPCPYSRCG) +  **********************/ /*BUG10215*/
/************             TOMBR(GPZOLSYNWH) MBROPT(*ADD)        **********************/ /*BUG10215*/
/************CPYF       FROMFILE(GPCPYSRG) TOFILE(GPCPYSRCG) +  **********************/ /*BUG10215*/
/************             TOMBR(GPZOLSYNSR) MBROPT(*ADD)        **********************/ /*BUG10215*/
             ENDDO
 
             GOTO CMDLBL(LOOP)
 
 ABNOR:
 
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM
