/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ML Setup temp files for DSPF conversion')       */
/********************************************************************/
/*                                                                  */
/*       Midas     - Utilities Module                               */
/*                                                                  */
/*       MLC0110  - SETUP TEMPORARY FILES                           */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUT004             Date 25Sep98              */
/*                      S01516             Date 18Jul94              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CUT004 - Allow Core and Non-Core mode of compilation for    */
/*                Multilanguage                                      */
/*       S01516 - Incorporation into core                           */
/*                                                                  */
/********************************************************************/
/************PGM********PARM(&SOURCE &LIBRAIRIE &SRCF &MSGFNM &MULTLIB)                   /*CUT004*/
             PGM        PARM(&SOURCE &LIBRAIRIE &SRCF &MSGFNM +
                          &MULTLIB &CORE &MSGFNX)                                         /*CUT004*/
 
             DCL        VAR(&WSTN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SOURCE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SOURCE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFNX) TYPE(*CHAR) LEN(10)                                  /*CUT004*/
             DCL        VAR(&LIBRAIRIE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MULTLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CORE) TYPE(*CHAR) LEN(1)                                     /*CUT004*/
             DCL        VAR(&SRCF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(200)
             DCL        VAR(&MODUL) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             RTVJOBA    JOB(&WSTN) USER(&USER)
 
             CHKOBJ     OBJ(QTEMP/RPGTEMP) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(TAG70))
             DLTF       FILE(QTEMP/RPGTEMP)
             MONMSG     MSGID(CPF0000)
 
 TAG70:
             CRTPF      FILE(QTEMP/RPGTEMP) RCDLEN(80) MBR(*NONE) +
                          SIZE(*NOMAX) SHARE(*NO) LVLCHK(*NO)
             MONMSG     MSGID(CPF3204 CPF7302) EXEC(DO)
             SNDPGMMSG  MSG('QTEMP/RPGTEMP not created +
                          ') TOMSGQ(&WSTN)
             GOTO       CMDLBL(FIN)
             ENDDO
 
/*    Copy DSPF source to temporary file                           */
             CPYF       FROMFILE(&LIBRAIRIE/&SRCF) +
                          TOFILE(QTEMP/RPGTEMP) FROMMBR(&SOURCE) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                          FMTOPT(*CVTSRC)
 
             DLTF       FILE(QTEMP/RPGOUTP)
             MONMSG     MSGID(CPF2105)
             CRTDUPOBJ  OBJ(RPGTEMP) FROMLIB(QTEMP) OBJTYPE(*FILE) +
                          NEWOBJ(RPGOUTP)
             MONMSG     MSGID(CPF3204 CPF7302) EXEC(DO)
             SNDPGMMSG  MSG('QTEMP/RPGOUTP not created +
                          ') TOMSGQ(&WSTN)
             GOTO       CMDLBL(FIN)
             ENDDO
 
 TAG81:
             CHGVAR     VAR(&MODUL) VALUE(%SST(&SRCF 1 2))
             CHGVAR     VAR(&SOURCE1) VALUE(&SOURCE)
 
/* Clear 'RPG-source affected by DDS change (SFL)' WORK FILE        */
 
             CLRPFM     FILE(SFLMSGPF)
             MONMSG     MSGID(CPF0000)
 
/* Change DDS source                                                */
 
/************CALL*******PGM(ML0130) PARM(&MSGFNM &SOURCE1 &LIBRAIRIE +                    /*CUT004*/
/*************************&MULTLIB &MODUL)                                                /*CUT004*/
             CALL       PGM(ML0130) PARM(&MSGFNM &SOURCE1 &LIBRAIRIE +
                          &MULTLIB &MODUL &CORE &MSGFNX)                                  /*CUT004*/
 
             CPYF       FROMFILE(QTEMP/RPGOUTP) +
                          TOFILE(&LIBRAIRIE/&SRCF) FROMMBR(&SOURCE) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                          FMTOPT(*CVTSRC) SRCOPT(*SEQNBR)
             RMVM       FILE(QTEMP/RPGTEMP) MBR(*ALL)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/RPGOUTP)
             MONMSG     MSGID(CPF2105)
 
/* Check for RPG source affected by the last DDS's change (SFL)    */
 
             CALL       PGM(MLC0130) PARM(&SOURCE &LIBRAIRIE &SRCF +
                          &MSGFNM &MULTLIB &MODUL)
 
 FIN:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             RETURN
             ENDPGM
