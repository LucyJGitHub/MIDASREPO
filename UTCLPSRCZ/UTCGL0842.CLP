/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Reporting/update utility for MD-54125')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       UTCGL0842 - Reporting/Updating Program for MD054125         */
/*                                                                   */
/*       (C) Finastra International Limited 2020                     */
/*                                                                   */
/*       Last Amend No. MD054125A          Date 17Aug20              */
/*       Prev Amend No. MD054125 *CREATE   Date 27Jul20              */
/*                      Xnnnnn             Date ddMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD054125A - Change the start date of records to be processed*/
/*                   to Nov. 2019.                                   */
/*       MD054125 - Datapatch to blank out Associated Customer (ASOC)*/
/*                  and merge the balances.                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM)

             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
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


/* Check if mode passed is 'A', 'a', 'U', 'u' or invalid */

             IF         COND((&PARM *NE 'A') *AND (&PARM *NE 'a') *AND (&PARM *NE +
                          'U') *AND (&PARM *NE 'u') ) THEN(DO)

                SNDPGMMSG  MSG('Invalid parameter. Call UTCGL0842 (''Mode'')') +
                             TOMSGQ(MOPERQ MRUNQ)

                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Mode should be +
                             either ''A'' or ''a'' for Audit and ''U'' or ''U'' +
                             for Update') MSGTYPE(*ESCAPE)
                GOTO       CMDLBL(END)
             ENDDO

/* Setup system prefix variable from SDSTAT data area */

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *CAT 'DPLIB   ')
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB   ')

/* Check if XXAPOSTPD and XXGLACPHPD exists */

             CHKOBJ     OBJ(&DPLIB/XXAPOSTPD) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(XXGLAC))
             DLTF       FILE(&DPLIB/XXAPOSTPD)

 XXGLAC:     CHKOBJ     OBJ(&DPLIB/XXGLACPHPD) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP1))
             DLTF       FILE(&DPLIB/XXGLACPHPD)

/* Backup ACCNTAB and GLACPHPD on Update mode */

 BACKUP1:    IF         COND((&PARM *EQ 'u') *OR (&PARM *EQ 'U')) THEN(DO)

                CPYF       FROMFILE(&DMLIB/APOSTPD) TOFILE(&DPLIB/XXAPOSTPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                   SNDPGMMSG  MSG('Error occurred in copying PF/APOSTPD to +
                                PF/XXAPOSTPD. Process terminated.') TOPGMQ(*EXT) +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ABNOR)
                ENDDO

                SNDPGMMSG  MSG('UTCGL0842A - Backup file XXAPOSTPD for APOSTPD +
                             created') TOMSGQ(MOPERQ)

                CPYF       FROMFILE(&DMLIB/GLACPHPD) TOFILE(&DPLIB/XXGLACPHPD) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                   SNDPGMMSG  MSG('Error occurred in copying PF/GLACPHPD to +
                                PF/XXGLACPHPD Process terminated.') TOPGMQ(*EXT) +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ABNOR)
                ENDDO

                SNDPGMMSG  MSG('UTCGL0842A - Backup file XXGLACPHPD for GLACPHPD +
                             created') TOMSGQ(MOPERQ)

             ENDDO

/* Call UTGL0842A program */

             CHGJOB     SWS(00000000)
             CALL       PGM(UTGL0842A) PARM(&PARM)

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)

                IF         COND((&PARM *EQ 'U') *OR (&PARM *EQ 'u')) THEN(DO)

                   CPYF       FROMFILE(&DPLIB/XXAPOSTPD) TOFILE(&DMLIB/APOSTPD) +
                                MBROPT(*REPLACE) FMTOPT(*NONE)

                   MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                      SNDUSRMSG  MSG('Error occurred in restoring PF/APOSTPD from +
                                   PF/XXAPOSTPD. Process terminated. Please +
                                   restore manually.') MSGTYPE(*INFO)
                   ENDDO

                   CPYF       FROMFILE(&DPLIB/XXGLACPHPD) TOFILE(&DMLIB/GLACPHPD) +
                                MBROPT(*REPLACE) FMTOPT(*NONE)

                   MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                      SNDUSRMSG  MSG('Error occurred in restoring PF/GLACPHPD from +
                                   PF/XXGLACPHPD. Process terminated. Please +
                                   restore manually.') MSGTYPE(*INFO)
                   ENDDO

                ENDDO
                GOTO       CMDLBL(ABNOR)
             ENDDO

             SNDPGMMSG  MSG('UTGL0842A completed normally') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)

/**Filter*postings*-*only*Posting*Date*and*Value*Date*after*31DEC2018 */               /*MD054125A*/
/* Filter postings - only Posting Date and Value Date after 31OCT2019 */               /*MD054125A*/

             IF         COND((&PARM *EQ 'U') *OR (&PARM *EQ 'u')) +
                          THEN(DO)
/**********  CPYF       FROMFILE(APOSTPD) TOFILE(QTEMP/APOSTPDXX) + */                 /*MD054125A*/
/**********               MBROPT(*REPLACE) CRTFILE(*YES) + */                          /*MD054125A*/
/**********               INCREL((*IF PSTD *GT 17167) (*AND VALD + */                  /*MD054125A*/
/**********               *GT 17167)) */                                               /*MD054125A*/
/**********  CPYF       FROMFILE(GLACPHPD) TOFILE(QTEMP/GLACPHPDXX) + */               /*MD054125A*/
/**********               MBROPT(*REPLACE) CRTFILE(*YES) + */                          /*MD054125A*/
/**********               INCREL((*IF PSTD *GT 17167) (*AND VALD + */                  /*MD054125A*/
/**********               *GT 17167)) */                                               /*MD054125A*/
             CPYF       FROMFILE(APOSTPD) TOFILE(QTEMP/APOSTPDXX) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF PSTD *GT 17471) (*AND VALD +
                          *GT 17471))                                                  /*MD054125A*/
             CPYF       FROMFILE(GLACPHPD) TOFILE(QTEMP/GLACPHPDXX) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF PSTD *GT 17471) (*AND VALD +
                          *GT 17471))                                                  /*MD054125A*/
             ENDDO

/* Check if XXGLHIBLPD exists */

             CHKOBJ     OBJ(&DPLIB/XXGLHIBLPD) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(XXAVBL))
             DLTF       FILE(&DPLIB/XXGLHIBLPD)

 XXAVBL:     CHKOBJ     OBJ(&DPLIB/XXGLAVBLPD) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP2))
             DLTF       FILE(&DPLIB/XXGLAVBLPD)

/* Backup GLHIBLPD file on Update mode */

 BACKUP2:    IF         COND((&PARM *EQ 'u') *OR (&PARM *EQ 'U')) THEN(DO)

                CPYF       FROMFILE(&DMLIB/GLHIBLPD) TOFILE(&DPLIB/XXGLHIBLPD) +
                              FROMMBR(*ALL) TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                              CRTFILE(*YES)
                MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                   SNDPGMMSG  MSG('Error occurred in copying PF/GLHIBLPD to +
                                PF/XXGLHIBLPD. Process terminated.') TOPGMQ(*EXT) +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ABNOR)
                ENDDO

                SNDPGMMSG  MSG('UTCGL0842 - Backup file XXGLHIBLPD for GLHIBLPD +
                             created') TOMSGQ(MOPERQ)

                CPYF       FROMFILE(&DMLIB/GLAVBLPD) TOFILE(&DPLIB/XXGLAVBLPD) +
                              FROMMBR(*ALL) TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                              CRTFILE(*YES)
                MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                   SNDPGMMSG  MSG('Error occurred in copying PF/GLAVBLPD to +
                                PF/XXGLAVBLPD. Process terminated.') TOPGMQ(*EXT) +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ABNOR)
                ENDDO

                SNDPGMMSG  MSG('UTCGL0842 - Backup file XXGLAVBLPD for GLAVBLPD +
                             created') TOMSGQ(MOPERQ)

             ENDDO

 READ:       RCVF       RCDFMT(GLHBCGD0)

/** End of File */

             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(EOF))

/**********  IF         COND(&HCLPDT *LT 17167235959) THEN(GOTO + */                   /*MD054125A*/
/**********               CMDLBL(READ)) */                                             /*MD054125A*/
             IF         COND(&HCLPDT *LT 17472235959) THEN(GOTO +
                          CMDLBL(READ))                                                /*MD054125A*/

/** Check if Control group exist as a member in GLHIBLPD  */

             CHKOBJ     OBJ(GLHIBLPD) OBJTYPE(*FILE) MBR(&HCCGCD)
             MONMSG     MSGID(CPF9815) EXEC(DO)
             GOTO       CMDLBL(READ)
             ENDDO

/** If member does not exists, add to member to file  */

             CHKOBJ     OBJ(GLHIBLL0) OBJTYPE(*FILE) MBR(&HCCGCD)
             MONMSG     MSGID(CPF9815) EXEC(DO)
             ADDLFM     FILE(GLHIBLL0) MBR(&HCCGCD) +
                          DTAMBRS((GLHIBLPD (&HCCGCD)))
             ENDDO

             CHKOBJ     OBJ(GLHIBLL1) OBJTYPE(*FILE) MBR(&HCCGCD)
             MONMSG     MSGID(CPF9815) EXEC(DO)
             ADDLFM     FILE(GLHIBLL1) MBR(&HCCGCD) +
                          DTAMBRS((GLHIBLPD (&HCCGCD)))
             ENDDO

             OVRDBF     FILE(GLHIBLL0) MBR(&HCCGCD) SHARE(*YES)
             OVRDBF     FILE(GLHIBLL1) MBR(&HCCGCD) SHARE(*YES)

             CHKOBJ     OBJ(GLAVBLL0) OBJTYPE(*FILE) MBR(&HCCGCD)
             MONMSG     MSGID(CPF9815) EXEC(DO)
             ADDLFM     FILE(GLAVBLL0) MBR(&HCCGCD) +
                          DTAMBRS((GLAVBLPD (&HCCGCD)))
             ENDDO

             CHKOBJ     OBJ(GLAVBLL1) OBJTYPE(*FILE) MBR(&HCCGCD)
             MONMSG     MSGID(CPF9815) EXEC(DO)
             ADDLFM     FILE(GLAVBLL1) MBR(&HCCGCD) +
                          DTAMBRS((GLAVBLPD (&HCCGCD)))
             ENDDO

             OVRDBF     FILE(GLAVBLL0) MBR(&HCCGCD) SHARE(*YES)
             OVRDBF     FILE(GLAVBLL1) MBR(&HCCGCD) SHARE(*YES)

/* Call UTGL0842B program */

             CHGJOB     SWS(00000000)
             CALL       PGM(UTGL0842B) PARM(&PARM)

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)

                IF         COND((&PARM *EQ 'U') *OR (&PARM *EQ 'u')) THEN(DO)

                   CPYF       FROMFILE(&DPLIB/XXGLHIBLPD) TOFILE(&DMLIB/GLHIBLPD) +
                                FROMMBR(*ALL) TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                                FMTOPT(*NONE)

                   MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                      SNDUSRMSG  MSG('Error occurred in restoring PF/GLHIBLPD from +
                                   PF/XXGLHIBLPD. Process terminated. Please +
                                   restore manually.') MSGTYPE(*INFO)
                   ENDDO

                   CPYF       FROMFILE(&DPLIB/XXGLAVBLPD) TOFILE(&DMLIB/GLAVBLPD) +
                                FROMMBR(*ALL) TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                                FMTOPT(*NONE)

                   MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                      SNDUSRMSG  MSG('Error occurred in restoring PF/GLAVBLPD from +
                                   PF/XXGLAVBLPD. Process terminated. Please +
                                   restore manually.') MSGTYPE(*INFO)
                   ENDDO

/**/
                ENDDO
                GOTO       CMDLBL(ABNOR)
             ENDDO

             DLTOVR     FILE(*ALL)

      IF         COND((&PARM *EQ 'U') *OR (&PARM *EQ 'u')) +
                          THEN(DO)

           IF COND(&HCPSTB = 'V') THEN(DO)
             OVRDBF     FILE(APOSTPD) TOFILE(QTEMP/APOSTPDXX)
             OVRDBF     FILE(GLACPHPD) TOFILE(QTEMP/GLACPHPDXX)
           ENDDO

             CPYF       FROMFILE(GLHIBLPD) TOFILE(QTEMP/GLHIBLPDXY) +
                          FROMMBR(*ALL) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE) CRTFILE(*YES)

/**********  CPYF       FROMFILE(QTEMP/GLHIBLPDXY) + */                                /*MD054125A*/
/**********               TOFILE(*LIBL/GLHIBLPD) FROMMBR(&HCCGCD) + */                 /*MD054125A*/
/**********               TOMBR(*FROMMBR) MBROPT(*REPLACE) + */                        /*MD054125A*/
/**********               CRTFILE(*NO) INCREL((*IF HBPDYR *NE '19')) */                /*MD054125A*/
             CPYF       FROMFILE(QTEMP/GLHIBLPDXY) +
                          TOFILE(*LIBL/GLHIBLPD) FROMMBR(&HCCGCD) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                          CRTFILE(*NO) INCREL((*IF HBSPDD *LT '17472'))                /*MD054125A*/

             CALL       PGM(MCC0264) PARM(&HCCGCD)
             DLTOVR     FILE(*ALL)

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)

                   CPYF       FROMFILE(&DPLIB/XXGLHIBLPD) TOFILE(&DMLIB/GLHIBLPD) +
                                FROMMBR(*ALL) TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                                FMTOPT(*NONE)

                   MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                      SNDUSRMSG  MSG('Error occurred in restoring PF/GLHIBLPD from +
                                   PF/XXGLHIBLPD. Process terminated. Please +
                                   restore manually.') MSGTYPE(*INFO)
                   ENDDO

                   CPYF       FROMFILE(&DPLIB/XXGLAVBLPD) TOFILE(&DMLIB/GLAVBLPD) +
                                FROMMBR(*ALL) TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                                FMTOPT(*NONE)

                   MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                      SNDUSRMSG  MSG('Error occurred in restoring PF/GLAVBLPD from +
                                   PF/XXGLAVBLPD. Process terminated. Please +
                                   restore manually.') MSGTYPE(*INFO)
                   ENDDO

                GOTO       CMDLBL(ABNOR)
             ENDDO
      ENDDO

             GOTO       CMDLBL(READ)

 ABNOR:
             SNDPGMMSG  MSG('Program UTCGL0842 ended abnormally - see joblog') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             DMPCLPGM

             GOTO       CMDLBL(END)

 EOF:        RCLRSC
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

             SNDPGMMSG  MSG('UTGL0842B completed normally') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)

             SNDPGMMSG  MSG('Program UTCGL0842 completed normally') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)

             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

 END:        ENDPGM
