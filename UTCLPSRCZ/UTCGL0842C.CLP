/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Reports account if CLBL/LDBL <> HBPDCB')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       UTCGL0842C - Compares Period Closing Balance of GLHIBLPD    */
/*                    to Cleared/Ledger Balance of ACCNTAB           */
/*                                                                   */
/*       (C) Finastra International Limited 2020                     */
/*                                                                   */
/*       Last Amend No. MD054125A *CREATE  Date 17Aug20              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD054125A - Reports accounts if Period Closing Balance is   */
/*                   not equal to Ledger/Cleared Balance.            */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2019')
             DCLF       FILE(GLHBCGPD)

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO CMDLBL(ABNOR))

/* Create LDA if doesn't exist  */

             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
                CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO

 READ:       RCVF       RCDFMT(GLHBCGD0)

/** End of File */

             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(EOF))

             IF         COND(&HCLPDT *LT 17471235959) THEN(GOTO +
                          CMDLBL(READ))

/** Check if Control group exist as a member in GLHIBLPD  */

             CHKOBJ     OBJ(GLHIBLPD) OBJTYPE(*FILE) MBR(&HCCGCD)
             MONMSG     MSGID(CPF9815) EXEC(DO)
             GOTO       CMDLBL(READ)
             ENDDO

/** If member does not exists, add member to file  */

             CHKOBJ     OBJ(UTHIBLL0) OBJTYPE(*FILE) MBR(&HCCGCD)
             MONMSG     MSGID(CPF9815) EXEC(DO)
             ADDLFM     FILE(UTHIBLL0) MBR(&HCCGCD) +
                          DTAMBRS((GLHIBLPD (&HCCGCD)))
             ENDDO

             CHKOBJ     OBJ(GLHIBLL3) OBJTYPE(*FILE) MBR(&HCCGCD)
             MONMSG     MSGID(CPF9815) EXEC(DO)
             ADDLFM     FILE(GLHIBLL3) MBR(&HCCGCD) +
                          DTAMBRS((GLHIBLPD (&HCCGCD)))
             ENDDO

             OVRDBF     FILE(UTHIBLL0) MBR(&HCCGCD) SHARE(*YES)
             OVRDBF     FILE(GLHIBLL3) MBR(&HCCGCD) SHARE(*YES)
             CLRPFM     UTGL842CPD

/* Call UTGL0842C program */

             CHGJOB     SWS(00000000)
             CALL       PGM(UTGL0842C) PARM(&HCPSTB)

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO

             DLTOVR     FILE(*ALL)

             GOTO       CMDLBL(READ)

 ABNOR:
             SNDPGMMSG  MSG('Program UTCGL0842C ended abnormally - see joblog') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             DMPCLPGM

             GOTO       CMDLBL(END)

 EOF:        RCLRSC
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

             SNDPGMMSG  MSG('UTGL0842C completed normally') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)

             SNDPGMMSG  MSG('Program UTCGL0842C completed normally') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)

             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

 END:        ENDPGM
