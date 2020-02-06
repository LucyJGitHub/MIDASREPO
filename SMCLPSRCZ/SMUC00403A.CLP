/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('CL program to call UTRE0671')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       SMUC00403A - CL PROGRAM TO CALL PGM/UTRE0671                */
/*                                                                   */
/*       (C) Finastra International Limited 2013                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD027435           Date 10Jun14              */
/*                      AR1055719 *CREATE  Date 25Nov13              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD027435 - UTCRE0671 renamed to SMUC00003A for upgrade      */
/*                  program standards.                               */
/*       AR1055719 - Wrong Retail Interest Rate. Created a utility   */
/*                   that will update pf/REHPOSRn with the correct   */
/*                   interest rate details based on pf/REIACD.       */
/*                   (Child: AR1055720)                              */
/*                 - Applied for MD023799                            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)
 
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2013')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR1))
 
/**********  SNDPGMMSG  MSG('UTCRE0671 - RE Accounts w/ incorrect +
                          Interest Type/Stype') TOMSGQ(MRUNQ)         */                /*MD027435*/
             SNDPGMMSG  MSG('SMUC00403A - RE Accounts w/ incorrect +
                          Interest Type/Stype') TOMSGQ(MRUNQ)                           /*MD027435*/
 
 
/* Create LDA if doesn't exist */
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO
 
/* Get system prefix */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
 
             CHGVAR     VAR(&DMLIB) VALUE(&PREF *TCAT 'DMLIB')
             CHGVAR     VAR(&DPLIB)  VALUE(&PREF *TCAT 'DPLIB')
 
/* Check if parameter passed is 'U', 'u', 'A' or 'a' or if invalid */
 
             IF         COND((&MODE *NE 'U') *AND (&MODE *NE 'u') +
                          *AND (&MODE *NE 'A') *AND (&MODE *NE +
                          'a')) THEN(DO)
 
/**********  SNDPGMMSG  MSG('Invalid parameter passed to +
                          UTCRE0671)') TOMSGQ(MOPERQ MRUNQ)           */                /*MD027435*/
             SNDPGMMSG  MSG('Invalid parameter passed to +
                          SMUC00403A)') TOMSGQ(MOPERQ MRUNQ)                            /*MD027435*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +
                          parameter. It should either be ''U'' or +
                          ''u'' for Update and ''A'' or ''a'' for +
                          Audit') MSGTYPE(*ESCAPE)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
 
             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                          THEN(DO)
 
/* Create backup of Retail History Files */
 
             DLTF       FILE(&DPLIB/XXREHPOSR1)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&DPLIB/XXREHPOSR2)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&DPLIB/XXREHPOSR3)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&DPLIB/XXREHISPD)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&DPLIB/XXREHISPS)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(&DMLIB/REHPOSR1) +
                          TOFILE(&DPLIB/XXREHPOSR1) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
 
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occured in copying PF/REHPOSR1 to +
                          PF/XXREHPOSR1. Process terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
 
             CPYF       FROMFILE(&DMLIB/REHPOSR2) +
                          TOFILE(&DPLIB/XXREHPOSR2) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
 
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occured in copying PF/REHPOSR2 to +
                          PF/XXREHPOSR2. Process terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
 
             CPYF       FROMFILE(&DMLIB/REHPOSR3) +
                          TOFILE(&DPLIB/XXREHPOSR3) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
 
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occured in copying PF/REHPOSR3 to +
                          PF/XXREHPOSR3. Process terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
 
             CPYF       FROMFILE(&DMLIB/REHISPD) +
                          TOFILE(&DPLIB/XXREHISPD) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
 
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occured in copying PF/REHISPD to +
                          PF/XXREHISPD. Process terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
 
             CPYF       FROMFILE(&DMLIB/REHISPS) +
                          TOFILE(&DPLIB/XXREHISPS) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
 
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occured in copying PF/REHISPS to +
                          PF/XXREHISPS. Process terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
 
/**********  SNDPGMMSG  MSG('UTCRE0671 - Backup files XXREHPOSR1/2/3 +
                          and XXREHISPD/S have been created') +
                          TOMSGQ(MOPERQ MRUNQ)                        */                /*MD027435*/
             SNDPGMMSG  MSG('SMUC00403A - Backup files XXREHPOSR1/2/3 +
                          and XXREHISPD/S have been created') +
                          TOMSGQ(MOPERQ MRUNQ)                                          /*MD027435*/
             ENDDO
 
/* Call the main program */
 
             CHGJOB     SWS(XXXXXX00)
 
/* Call PGM/UTRE0671 */
 
             CALL       PGM(UTRE0671) PARM(&MODE)
 
/* Error occured in main program */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
 /* Delete backup file after the program completed normally*/
 /* UPDATE mode */
 
              IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                           THEN(DO)
 
              DLTF       FILE(&DPLIB/XXREHPOSR1)
              MONMSG     MSGID(CPF0000)
              DLTF       FILE(&DPLIB/XXREHPOSR2)
              MONMSG     MSGID(CPF0000)
              DLTF       FILE(&DPLIB/XXREHPOSR3)
              MONMSG     MSGID(CPF0000)
              DLTF       FILE(&DPLIB/XXREHISPD)
              MONMSG     MSGID(CPF0000)
              DLTF       FILE(&DPLIB/XXREHISPS)
              MONMSG     MSGID(CPF0000)
 
              ENDDO
 
/**********   SNDPGMMSG  MSG('UTCRE0671 completed normally') +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)          */                /*MD027435*/
              SNDPGMMSG  MSG('SMUC00403A completed normally') +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)                            /*MD027435*/
              GOTO       CMDLBL(END)
 
/**Abnormal*termination*of*PGM/UTCRE0671**/                                             /*MD027435*/
/* Abnormal termination of PGM/SMUC00403A */                                            /*MD027435*/
 
 ABNOR:      IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                          THEN(DO)
 
/* Restore backup of RE History files */
 
             CPYF       FROMFILE(&DPLIB/XXREHPOSR1) +
                          TOFILE(&DMLIB/REHPOSR1) MBROPT(*REPLACE)
 
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occured in copying PF/XXREHPOSR1 +
                          to PF/REHPOSR1. Please restore manually. +
                          Process terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
 
             CPYF       FROMFILE(&DPLIB/XXREHPOSR2) +
                          TOFILE(&DMLIB/REHPOSR2) MBROPT(*REPLACE)
 
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occured in copying PF/XXREHPOSR2 +
                          to PF/REHPOSR2. Please restore manually. +
                          Process terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
 
             CPYF       FROMFILE(&DPLIB/XXREHPOSR3) +
                          TOFILE(&DMLIB/REHPOSR3) MBROPT(*REPLACE)
 
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occured in copying PF/XXREHPOSR3 +
                          to PF/REHPOSR3. Please restore manually. +
                          Process terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
 
             CPYF       FROMFILE(&DPLIB/XXREHISPD) +
                          TOFILE(&DMLIB/REHISPD) MBROPT(*REPLACE)
 
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occured in copying PF/XXREHISPD +
                          to PF/REHISPD. Please restore manually. +
                          Process terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
 
             CPYF       FROMFILE(&DPLIB/XXREHISPS) +
                          TOFILE(&DMLIB/REHISPS) MBROPT(*REPLACE)
 
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occured in copying PF/XXREHISPS +
                          to PF/REHISPS. Please restore manually. +
                          Process terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
 
/**********  SNDPGMMSG  MSG('UTCRE0671 - Backup files XXREHPOSR1/2/3 +
                          and XXREHISPD/S have been restored') +
                          TOMSGQ(MOPERQ MRUNQ)                        */                /*MD027435*/
             SNDPGMMSG  MSG('SMUC00403A - Backup files XXREHPOSR1/2/3 +
                          and XXREHISPD/S have been restored') +
                          TOMSGQ(MOPERQ MRUNQ)                                          /*MD027435*/
             GOTO       CMDLBL(END)
             ENDDO
 
/********** ABNOR1:     SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          UTCRE0671 ended abnormally - see joblog') +
                          TOMSGQ(MOPERQ)                              */                /*MD027435*/
 ABNOR1:     SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SMUC00403A ended abnormally - see joblog') +
                          TOMSGQ(MOPERQ)                                                /*MD027435*/
             DMPCLPGM
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Systems 2013')
             ENDPGM
