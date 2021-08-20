/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME Download SWIFT BIC Dir from Optical CD')     */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Message Management Module                       */
/*                                                                   */
/*       MECL003  - Download SWIFT BIC Directory from Optical CD     */
/*                                                                   */
/*       (C) Copyright Misys International Banking Systems Ltd.      */
/*                                                                   */
/*       Last Amend No. MD031937           Date 13Jan15              */
/*       Prev Amend No. AR856737           Date 13Sep11              */
/*                      LFT001             Date 25JUL2002            */
/*                      djbemg  *Create    Date 22Feb2002            */
/*                                                                   */
/*********************************************************************/
/*       MD031937 - Upgrade STP enhancements to BF Midas 2.1         */
/*       AR856737 - Upgrade STP enhancements to Midas Plus level     */
/*      LFT001 - New BIC Directory load                              */
/*      EMEFIX - CPYFROMCD using the correct quater.                 */
/*      djbemg - Download of data SWIFT Dos CD                       */
/*               Replaces MECL001                                    */
/*                                                                   */
/*********************************************************************/
             PGM
/* */
             DCL        VAR(&CPY) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          Copyright Misys International Banking +
                          Systems Ltd. 2002')
/* */
/* Declare path for copy */
/* */
             DCL        VAR(&DLONAME) TYPE(*CHAR) LEN(14)
             DCL        VAR(&PATH) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REOPN) TYPE(*CHAR) LEN(1) VALUE('1')
             DCL        VAR(&NOREPLY) TYPE(*CHAR)  LEN(1)
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(132)
                                                                                         /*DJB001*/
             DCL        VAR(&SRTCD) TYPE(*CHAR) LEN(7)                                   /*DJB001*/
             DCL        VAR(&SOPTN) TYPE(*CHAR) LEN(7)                                   /*DJB001*/
             DCL        VAR(&SSARD) TYPE(*CHAR) LEN(6)                                   /*DJB001*/
             DCL        VAR(&SSCSARD) TYPE(*CHAR) LEN(200)                               /*DJB001*/
 
/* */
/* Declare file for Optical Analysis */
/* */
             DCLF       FILE(QAMODVAF)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Set switches */
/* */
             CHGJOB     SWS(XXXXX000)
/* */
/* Create BIC Folder */
/* */
             CRTFLR     FLR(SWIFTD.BIC) TEXT('SWIFT BIC Dir. +
                          Download From Optical Store')
             MONMSG     MSGID(CPF8A18)
/* */
/* Prompt for selection of quarter  */
/* */
 Loopq:      CALL       PGM(MEC1027) PARM(&RTN_CODE 'XXA0001' +
                          'XXUSRMSG ' &MSGDTA 'OPTION2   ' &REOPN +
                          'MECL003' 'Y')
/* */
/* If 1 to 4 and cancel otherwise loop */
/* */
             IF         COND((&REOPN = '1' *or +
                              &REOPN = '2' *or +
                              &REOPN = '3' *or +
                              &REOPN = '4' *or +
                              &REOPN = 'C'     )) THEN(DO)
             IF         COND(&REOPN = 'C') THEN(GOTO CMDLBL(ENDCLPGM))
             ENDDO
             ELSE       CMD(DO)
             GOTO       CMDLBL(Loopq)
             ENDDO
/* */
/* Delete BIC Bank file download */
/* */
             CHGVAR     VAR(&DLONAME) VALUE('BICDUCT' *CAT &REOPN +
                          *CAT '.DOS')
             DLTDLO     DLO(&DLONAME) FLR(SWIFTD.BIC)
             MONMSG     MSGID(CPF8A16)
             CHGVAR     VAR(&DLONAME) VALUE('BICDUCU' *CAT &REOPN +
                          *CAT '.DOS')
             DLTDLO     DLO(&DLONAME) FLR(SWIFTD.BIC)
             MONMSG     MSGID(CPF8A16)
             CHGVAR     VAR(&DLONAME) VALUE('BICDUFI' *CAT &REOPN +
                          *CAT '.DOS')
             DLTDLO     DLO(&DLONAME) FLR(SWIFTD.BIC)
             MONMSG     MSGID(CPF8A16)
             CHGVAR     VAR(&DLONAME) VALUE('BICDUHD' *CAT &REOPN +
                          *CAT '.DOS')
             DLTDLO     DLO(&DLONAME) FLR(SWIFTD.BIC)
             MONMSG     MSGID(CPF8A16)
/* */
/* Display Optical Volume */
/* */
             DSPOPT     VOL(*ALL) DATA(*VOLATR) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/OPTIC.DAT)
             OVRDBF     FILE(QAMODVAF) TOFILE(QTEMP/OPTIC.DAT)
             RCVF
/* */                                                                                    /*DJB001*/
/* Check for new BIC directory */                                                        /*DJB001*/
/* */                                                                                    /*DJB001*/
             CHGVAR     VAR(&SRTCD) VALUE('       ')                                     /*DJB001*/
             CHGVAR     VAR(&SOPTN) VALUE('*VERIFY')                                     /*DJB001*/
             CHGVAR     VAR(&SSARD) VALUE('LFT001')                                      /*DJB001*/
                                                                                         /*DJB001*/
             CALL       PGM(AOSARDR0) PARM(&SRTCD &SOPTN &SSARD +
                          &SSCSARD)                                                      /*DJB001*/
                                                                                         /*DJB001*/
             IF         COND((&SRTCD *EQ '       ') *AND (&SRTCD *NE +
                          '*NRF   ')) THEN(DO)                                           /*DJB001*/
             CHGVAR     VAR(&OVNAME) VALUE(&OVNAME +
                          *TCAT '/BICDU')                                                /*DJB001*/
             ENDDO                                                                       /*DJB001*/
/* */
/* Copy from Optical Drive */
/* */
             CHGVAR     VAR(&DLONAME) VALUE('/BICDUCU' *CAT &REOPN +
                          *CAT '.DOS')
             CHGVAR     VAR(&PATH) VALUE('/QOPT/' *CAT &OVNAME +
                          *TCAT &DLONAME)
             CPY        OBJ(&PATH) +
                          TODIR('/QDLS/SWIFTD.BIC/')
             MONMSG     MSGID(CPFA0A9) EXEC(DO)
             CHGVAR     VAR(&MSGDTA) VALUE(&PATH)
             CALL       PGM(MEC1027) PARM(&RTN_CODE 'XXA0002' +
                          'XXUSRMSG ' &MSGDTA 'ENTER     ' &REOPN +
                          'MECL003' 'Y')
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
             MONMSG     MSGID(CPFA09C) EXEC(DO)
             CHGVAR     VAR(&MSGDTA) VALUE(&PATH)
             CALL       PGM(MEC1027) PARM(&RTN_CODE 'XXA0003' +
                          'XXUSRMSG ' &MSGDTA 'ENTER     ' &REOPN +
                          'MECL003' 'Y')
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
             CHGVAR     VAR(&DLONAME) VALUE('/BICDUCT' *CAT &REOPN +
                          *CAT '.DOS')
             CHGVAR     VAR(&PATH) VALUE('/QOPT/' *CAT &OVNAME +
                          *TCAT &DLONAME)
             CPY        OBJ(&PATH) +
                          TODIR('/QDLS/SWIFTD.BIC/')
             CHGVAR     VAR(&DLONAME) VALUE('/BICDUFI' *CAT &REOPN +
                          *CAT '.DOS')
             CHGVAR     VAR(&PATH) VALUE('/QOPT/' *CAT &OVNAME +
                          *TCAT &DLONAME)
             CPY        OBJ(&PATH) +
                          TODIR('/QDLS/SWIFTD.BIC/')
             CHGVAR     VAR(&DLONAME) VALUE('/BICDUHD' *CAT &REOPN +
                          *CAT '.DOS')
             CHGVAR     VAR(&PATH) VALUE('/QOPT/' *CAT &OVNAME +
                          *TCAT &DLONAME)
             CPY        OBJ(&PATH) +
                          TODIR('/QDLS/SWIFTD.BIC/')
/* */
/* Create temporary BIC Directory file */
/* */
             DLTF       FILE(QTEMP/MEBICDF)
             MONMSG     MSGID(CPF2105)
/* */
             RTVOBJD    OBJ(MEBICDF) OBJTYPE(*FILE) RTNLIB(&DPLIB)
/* */
             CRTPF      FILE(QTEMP/MEBICDF) RCDLEN(848) TEXT('Midas +
                          SWIFT BIC Directory') SIZE(*NOMAX)
/* */
/* Copy from PC File to Data base file */
/* */
             CHGVAR     VAR(&DLONAME) VALUE('BICDUFI' *CAT &REOPN +
                          *CAT '.DOS')
             CPYFRMPCD  FROMFLR(SWIFTD.BIC) TOFILE(QTEMP/MEBICDF) +
                          FROMDOC(&DLONAME) TRNFMT(*NOTEXT)
/* */
/* Copy contents to MEBICDF */
/* */
             CPYF       FROMFILE(QTEMP/MEBICDF) +
                          TOFILE(&DPLIB/MEBICDF) MBROPT(*REPLACE) +
                          FMTOPT(*NOCHK)
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program MECL003 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MECL003 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             RCLRSC
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPY) VALUE('COPYRIGHT Misys +
                          International Banking Systems Ltd. 2002.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
/* */
             ENDPGM
