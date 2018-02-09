/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Layout description  F...... file')           */
/*OVR  : OVRDBF JRNOUT QSYS/QAFDPHY                                 :*/
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0112  - CREATE AND RECREATE THE F FILES                  */
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
/*       Prev Amend No. S01379             Date 15Sep92              */
/*                                         Date                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*   Compiler directive for file JRNOUT                              */
/*********************************************************************/
 
             PGM        PARM(&UACT &FLGL &PHY1 &PHY2 &PHY3 &PHY4 +
                          &PHY5 &PHY6 &POK &TEXT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&UACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FLGL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PHY1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PHY2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PHY3) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PHY4) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PHY5) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PHY6) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(25)
             DCL        VAR(&TEXT2) TYPE(*CHAR) LEN(45)
             DCL        VAR(&POK) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NBRCUR) TYPE(*DEC) LEN(10)
             DCL        VAR(&HFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LID) TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSSV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSPG) TYPE(*CHAR) LEN(10) VALUE('HFC0112')
             DCL        VAR(&MSFM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSRP) TYPE(*CHAR) LEN(1)
 
 
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             CHGJOB     LOG(4 00 *MSG) LOGCLPGM(*YES)
 
/* */
/*  Set up the text */
/* */
             CHGVAR     VAR(&TEXT2) VALUE('Midas HF' *BCAT +
                          &TEXT)
 
/* */
/* Get library ID and build the HFLIB variable */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LID)
             CHGVAR     VAR(&HFLIB) VALUE(&LID *CAT 'HFLIB')
 
/* */
/* Set up 'F' version of file name */
/* */
             CHGVAR     VAR(%SST(&FLGL 1 1)) VALUE('F')
 
/* */
/* Set default return code to Ok */
/* */
             CHGVAR     VAR(&POK) VALUE('Y')
 
/* */
/* Ensure that the extract file does not exist in QTEMP */
/* */
             DLTF       FILE(QTEMP/&FLGL)
             MONMSG     MSGID(CPF0000)
 
 
/* */
/* If action code Amend then save the current version of the file */
/* */
             IF         COND(&UACT *EQ 'A') THEN(DO)
             CPYF       FROMFILE(&HFLIB/&FLGL) TOFILE(QTEMP/&FLGL) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*ADD) CRTFILE(*YES)
 
/* */
/* Send message so user knows it hasn't stopped */
/* */
             CHGVAR     VAR(&MSGID) VALUE('HFM0009')
             CHGVAR     VAR(&MSSV) VALUE(*BLANKS)
/* */
             CALL       PGM(HFC0012) PARM(&MSGID &MSSV)
/* */
             CHGVAR     VAR(&MSPG) VALUE('HFC0112')
             CHGVAR     VAR(&MSFM) VALUE('MIDASMSG')
             CHGVAR     VAR(&MSRP) VALUE(*BLANKS)
/* */
             CALL       PGM(HFC0010) PARM(&MSPG &MSFM &MSRP)
 
 
             ENDDO
 
/* */
/* Now delete the original version of the file */
/* */
             DLTF       FILE(&HFLIB/&FLGL)
             MONMSG     MSGID(CPF0000)
 
/* */
/* PHYS-FILE 1 */
/* */
             IF         COND(&PHY1 *NE '          ') THEN(DO)
             DSPFFD     FILE(*LIBL/&PHY1) OUTPUT(*OUTFILE) +
                          OUTFILE(&HFLIB/&FLGL) OUTMBR(*FIRST *ADD)
             ENDDO
 
/* */
/* PHYS-FILE 2 */
/* */
             IF         COND(&PHY2 *NE '          ') THEN(DO)
             DSPFFD     FILE(*LIBL/&PHY2) OUTPUT(*OUTFILE) +
                          OUTFILE(&HFLIB/&FLGL) OUTMBR(*FIRST *ADD)
             ENDDO
 
/* */
/* PHYS-FILE 3 */
/* */
             IF         COND(&PHY3 *NE '          ') THEN(DO)
             DSPFFD     FILE(*LIBL/&PHY3) OUTPUT(*OUTFILE) +
                          OUTFILE(&HFLIB/&FLGL) OUTMBR(*FIRST *ADD)
             ENDDO
 
/* */
/* PHYS-FILE 4 */
/* */
             IF         COND(&PHY4 *NE '          ') THEN(DO)
             DSPFFD     FILE(*LIBL/&PHY4) OUTPUT(*OUTFILE) +
                          OUTFILE(&HFLIB/&FLGL) OUTMBR(*FIRST *ADD)
             ENDDO
 
/* */
/* PHYS-FILE 5 */
/* */
             IF         COND(&PHY5 *NE '          ') THEN(DO)
             DSPFFD     FILE(*LIBL/&PHY5) OUTPUT(*OUTFILE) +
                          OUTFILE(&HFLIB/&FLGL) OUTMBR(*FIRST *ADD)
             ENDDO
 
/* */
/* PHYS-FILE 6 */
/* */
             IF         COND(&PHY6 *NE '          ') THEN(DO)
             DSPFFD     FILE(*LIBL/&PHY6) OUTPUT(*OUTFILE) +
                          OUTFILE(&HFLIB/&FLGL) OUTMBR(*FIRST *ADD)
             ENDDO
 
             CHGPF      FILE(&HFLIB/&FLGL) TEXT(&TEXT2)
 
             GRTOBJAUT  OBJ(&HFLIB/&FLGL) OBJTYPE(*FILE) +
                          USER(*PUBLIC) AUT(*ALL)
             RTVMBRD    FILE(&HFLIB/&FLGL) NBRCURRCD(&NBRCUR)
             IF         COND(&NBRCUR *GT 500) THEN(DO)
             CALL       PGM(HFC0310) PARM('Not allowed to specify +
                          more than 500 Fields' ' ')
             GOTO       CMDLBL(ERROR)
             ENDDO
 
             GOTO       CMDLBL(END)
 
ERROR:
/* */
/* RESTORE OLD FILE */
/* */
             DLTF       FILE(&HFLIB/&FLGL)
             MONMSG     MSGID(CPF0000)
             MOVOBJ     OBJ(QTEMP/&FLGL) OBJTYPE(*FILE) TOLIB(&HFLIB)
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&POK) VALUE('N')
             MONMSG     MSGID(CPF0000)
 
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             CHGVAR     VAR(%SST(&FLGL 1 1)) VALUE('J')
             MONMSG     MSGID(CPF0000)
             ENDPGM
