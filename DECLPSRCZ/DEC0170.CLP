/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DE Submit Bulk Download during Input Cycle')    */
/*OVR  : OVRDBF FILE(FDMBR) TOFILE(QAFDMBRL)                        :*/                   /*208221*/
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0170 - Submit Bulk Download during Input Cycle           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/*                      208221             Date 11Dec02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CDE002  *CREATE    Date 12Jun01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       208221 - Changes identified during alpha site               */
/*       CDE002 - Data Export - CCRM Revenue Analysis                */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,DEC0170INT                                          */
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CDE001) TYPE(*CHAR) LEN(1) VALUE('N' )
             DCL        VAR(&CDE002) TYPE(*CHAR) LEN(1) VALUE('N' )
             DCL        VAR(&FHDC) TYPE(*CHAR) LEN(1)                                     /*208221*/
             DCLF       FILE(QTEMP/FDMBR)                                                 /*208221*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/* Determine if CCRM Limits is installed */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SARD) VALUE('CDE001')
 
             CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)
 
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDE001) VALUE('Y'))
 
/* Determine if CCRM Revenue Analysis installed */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SARD) VALUE('CDE002')
 
             CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)
 
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CDE002) VALUE('Y'))
 
/*/COPY WNCPYSRC,DEC0170MPS                                          */
 
/*                                                                                       * *208221*/
/* Retrieve data area for full historic download complete flag                           * *208221*/
/*                                                                                       * *208221*/
               RTVDTAARA  DTAARA(DEEXTCTL (46 1)) RTNVAR(&FHDC)                           /*208221*/
                                                                                          /*208221*/
               IF         COND(&FHDC *EQ 'Y') THEN(DO)                                    /*208221*/
                CHGVAR     VAR(&FHDC) VALUE(' ')                                          /*208221*/
                CHGDTAARA  DTAARA(DEEXTCTL (46 1)) VALUE(&FHDC)                           /*208221*/
                DSPFD      FILE(DEHTRANPD) TYPE(*MBRLIST) +
                            OUTPUT(*OUTFILE) OUTFILE(QTEMP/FDMBR)                         /*208221*/
                                                                                          /*208221*/
LOOP:           RCVF                                                                      /*208221*/
                MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(FINISH))                       /*208221*/
                                                                                          /*208221*/
                IF         COND(&MLNAME *NE 'INT') THEN(DO)                               /*208221*/
                                                                                          /*208221*/
                 CPYF       FROMFILE(DEOTRANPD) TOFILE(DEHTRANPD) +
                             FROMMBR(&MLNAME) TOMBR(&MLNAME) MBROPT(*REPLACE)             /*208221*/
                 MONMSG CPF0000                                                           /*208221*/
                 CPYF       FROMFILE(DEOPOSNPD) TOFILE(DEHPOSNPD) +
                             FROMMBR(&MLNAME) TOMBR(&MLNAME) MBROPT(*REPLACE)             /*208221*/
                 MONMSG CPF0000                                                           /*208221*/
                 CPYF       FROMFILE(DEOEVNTPD) TOFILE(DEHEVNTPD) +
                             FROMMBR(&MLNAME) TOMBR(INT) MBROPT(*ADD)                     /*208221*/
                 MONMSG CPF0000                                                           /*208221*/
/*                                                                                       * *208221*/
/* Historic Transaction Comparison and Selection Control                                 * *208221*/
/*                                                                                       * *208221*/
                 CALL       PGM(DEC0210) PARM(&MLNAME)                                    /*208221*/
/*                                                                                       * *208221*/
/* Historic Position Comparison and Selection Control                                    * *208221*/
/*                                                                                       * *208221*/
                 CALL       PGM(DEC0220) PARM(&MLNAME)                                    /*208221*/
/*                                                                                       * *208221*/
/* Historic Events Comparison and Selection Control                                      * *208221*/
/*                                                                                       * *208221*/
                 CALL       PGM(DEC0230) PARM(&MLNAME)                                    /*208221*/
                                                                                          /*208221*/
                ENDDO                                                                     /*208221*/
                                                                                          /*208221*/
                GOTO       CMDLBL(LOOP)                                                   /*208221*/
/*                                                                                       * *208221*/
/* Delete temporary file as DEC0080 will create it again                                 * *208221*/
/*                                                                                       * *208221*/
FINISH:         DLTF       FILE(QTEMP/FDMBR)                                              /*208221*/
/*                                                                                       * *208221*/
/* Merge Historic Extract Files for Transfer                                             * *208221*/
/*                                                                                       * *208221*/
                CALL       DEC0080                                                        /*208221*/
                CHGVAR     VAR(&FHDC) VALUE('Y')                                          /*208221*/
                CHGDTAARA  DTAARA(DEEXTCTL (46 1)) VALUE(&FHDC)                           /*208221*/
                                                                                          /*208221*/
               ENDDO                                                                      /*208221*/
/*                                                                                       * *208221*/
/* Send Start of Resynchronisation message */
 
             CALL       PGM(DEC0160) PARM('RS')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
/* Send Standing Data common to Limits and Revenue */
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MSDBANKPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MSDACOFPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MSDBRCHPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MSDCOMPPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MSDCTRYPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MSDCURRPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MSDCUSTPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MSDINDSPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MSDINSTPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MSDLOANPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MINVTPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MFDDTSTPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MDEACEXPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
/* Send Standing Data just for Revenue */
 
             IF         COND(&CDE002 *EQ 'Y') THEN(DO)
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MSDFACTPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MSDFEEPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MSDCUHSPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             ENDDO
 
/* Send Transaction Data for Limits */
 
             IF         COND(&CDE001 *EQ 'Y') THEN(DO)
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MDETTRANPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MDETPOSNPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MDETEVNTPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MDETCASHPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             ENDDO
 
/* Send Transaction Data for Revenue */
 
             IF         COND(&CDE002 *EQ 'Y') THEN(DO)
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MDENTRANPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MDENPOSNPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             CALL       PGM(MXC0700) PARM('*NONE' 'C' 'MDENEVNTPD')
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
             ENDDO
 
/* Send End of Resynchronisation message */
 
/************SBMJOB     JOB(DEC0160) JOBD(MBATCH) USER(*JOBD) +                           /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL DEC0160 +                            /*CSC023*/
/************             PARM(RE)') INLLIBL(*JOBD) MSGQ(MOPERQ)                          /*CSC023*/
             SBMJOB     JOB(DEC0160) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL DEC0160 +
                          PARM(RE)') INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)              /*CSC023*/
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                         /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
 
/*    Error processing                                               */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                  GOTO       CMDLBL(END)
                ENDDO
 
 
/*/COPY WNCPYSRC,DEC0170MPE                                          */
 
            GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DEC0170ERR                                          */
 
/* Abnormal termination */
 
               CHGJOB     SWS(XXXXXX11)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0170 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,DEC0170END                                          */
 
ENDPGM
