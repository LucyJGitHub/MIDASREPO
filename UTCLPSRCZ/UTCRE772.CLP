/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('CL to Call UTRE0772 - Accounts Discrepancy')          */
/*********************************************************************/
/*                                                                   */
/*       Midas Retail Module                                         */
/*                                                                   */
/*       UTCRE772  - CL program to call datapatch UTRE0772           */
/*                                                                   */
/*       (c) Finastra International Limited 2023                     */
/*                                                                   */
/*       Last Amend No. MD035660 *Create   Date 16Jun23              */
/*       Prev Amend No. MDnnnnnn           Date ddMmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD035660 - No fee settlement posting in Retail history file.*/
/*                  Utility to correct discrepancies between history */
/*                  balance and account balance files.               */
/*                - MD061267 - Credit Lines (CLE025) fixes           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)

             DCL        VAR(&BISCPY) TYPE(*CHAR) LEN(64) VALUE('(C) Finastra +
                          International Limited 2023')

             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DVLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&UCLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCLF       FILE(SDRETLPD)

             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)

             SNDPGMMSG  MSG('UTCRE772 - Accounts Discrepancy Report') TOMSGQ(MRUNQ +
                          MOPERQ)

             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO

/** Get system prefix */

             RTVDTAARA  DTAARA(SDSTAT *ALL) RTNVAR(&SDSTAT)

             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&DPLIB) VALUE(&PRE *TCAT 'DPLIB')
             CHGVAR     VAR(&DVLIB) VALUE(&PRE *TCAT 'DVLIB')
             CHGVAR     VAR(&UCLIB) VALUE(&PRE *TCAT 'UCLIB')

             IF         COND((&MODE *NE 'U') *AND (&MODE *NE 'u') +
                        *AND (&MODE *NE 'A') *AND (&MODE *NE +
                        'a')) THEN(DO)
                SNDPGMMSG  MSG('Invalid parameter passed - UTCRE772') TOPGMQ(*EXT) +
                             TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
             ELSE       CMD(DO)
/**/
             OVRDBF     REACCNJL REACRD SHARE(*YES)
/**/
             RCVF       RCDFMT(SDRETLD0)
             IF         COND(&BMCBAI *NE 'Y') +
             THEN(DO)
             OPNQRYF    FILE((REACRD) (ACCNTAB)) FORMAT(REACCNJL) +
                          QRYSLT('REACRD/RECI *EQ "D"') +
                          KEYFLD((ZBRCA) (ZCUST) (ZACCY) (ZACOD) +
                          (ZASEQ)) JFLD((ACCNTAB/BRCA +
                          *MAPFLD/ZBRCA) (ACCNTAB/CNUM +
                          *MAPFLD/ZCUST) (ACCNTAB/CCY +
                          *MAPFLD/ZACCY) (ACCNTAB/ACOD +
                          *MAPFLD/ZACOD) (ACCNTAB/ACSQ +
                          *MAPFLD/ZASEQ) (ACCNTAB/LDBL +
                          *MAPFLD/ZLDBL)) JDFTVAL(*ONLYDFT) +
                          MAPFLD((ZLDBL '1/HISB - 1/GADI + 1/GACI' +
                          *DEC 15 0) (ZBRCA '1/BRCA') (ZCUST +
                          '1/CUST') (ZACCY '1/ACCY') (ZACOD +
                          '1/ACOD') (ZASEQ '1/ASEQ') (ZHISB +
                          '1/HISB') (ZGADI '1/GADI') (ZGACI +
                          '1/GACI') (ZACOQQ '1/ACODQQ')) +
                          IGNDECERR(*YES)
             ENDDO

             IF         COND(&BMCBAI *EQ 'Y') +
             THEN(DO)
             OPNQRYF    FILE((REACRD) (ACCNTAB)) FORMAT(REACCNJL) +
                          QRYSLT('REACRD/RECI *EQ "D"') +
                          KEYFLD((ZBRCA) (ZCUST) (ZACCY) (ZACOD) +
                          (ZASEQ)) JFLD((*MAPFLD/ZBRCA +
                          ACCNTAB/BRCA) (*MAPFLD/ZCUST +
                          ACCNTAB/CNUM) (*MAPFLD/ZACCY ACCNTAB/CCY) +
                          (*MAPFLD/ZACOD ACCNTAB/ACOD) +
                          (*MAPFLD/ZASEQ ACCNTAB/ACSQ) +
                          (*MAPFLD/HSGA ACCNTAB/CLBL)) +
                          JDFTVAL(*ONLYDFT) MAPFLD((HSGA '1/HISB - +
                          1/GADI + 1/GACI' *DEC 15 0) (ZBRCA +
                          '1/BRCA') (ZCUST '1/CUST') (ZACCY +
                          '1/ACCY') (ZACOD '1/ACOD') (ZASEQ +
                          '1/ASEQ') (ZHISB '1/HISB') (ZGADI +
                          '1/GADI') (ZGACI '1/GACI') (ZACOQQ +
                          '1/ACODQQ')) IGNDECERR(*YES)
             ENDDO
             CHGJOB     SWS(00000000)
             CALL       PGM(UTRE0772) PARM(&MODE)

             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
             SNDPGMMSG  MSG('JOB TERMINATED - DATABASE ERROR') +
                          TOMSGQ(MOPERQ MRUNQ)

             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO

/** Program completed normally */

             SNDPGMMSG  MSG('Program UTCRE772 completed normally') TOMSGQ(MOPERQ +
                          MRUNQ)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO

ABNORMAL:    RCLRSC     LVL(*)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSG('Program UTCRE772 ended abnormally') TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program UTCRE772 +
                          ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

 ENDCLPGM:
             RCLRSC     LVL(*)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&BISCPY) VALUE('(c) Finastra International Limited +
                          2023')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

             ENDPGM
