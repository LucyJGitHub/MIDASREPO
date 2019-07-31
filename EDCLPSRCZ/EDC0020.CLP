/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Bulk transfer')                              */
/********************************************************************/
/*                                                                  */
/*       Midas - Midas Export Data Interface Module                 */
/*                                                                  */
/*       EDC0020 - Bulk Transfer Component                          */
/*                                                                  */
/*       Function : This program controls the creation of batches   */
/*                  and the copying of files into them.             */
/*                                                                  */
/*       Submitted by : COB Process                                 */
/*                                                                  */
/*       Calls :        ED0020                                      */
/*                      AOMEXPR0                                    */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      118268             DATE 01SEP97             */
/*                      CED002             DATE 01SEP97             */
/*                      117467             DATE 30APR97             */
/*                      CED001             DATE 19AUG96             */
/*                      101971             DATE 17JUL95             */
/*                      S01408             DATE 19JUN95             */
/*                      S01493 *CREATE     DATE 16MAY94             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB009 - Journal files throughout close of business         */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       118268 - DSPFD output file not recreated for multiple      */
/*                members of the same file.                         */
/*       CED002 - Midas ED Enhancements                             */
/*                Recompile only for change to EDFBUTPD             */
/*       117467 - Addition of special case user defined batch proc. */
/*       CED001 - Export Data Phases III & IV                       */
/*       101971 - Phase II Modifications                            */
/*       S01408 - Addition of core hook EDC0020MP1                  */
/*       S01493 - Midas Export Data  Interface Module               */
/*                                                                  */
/********************************************************************/
/************PGM        PARM(&STREAM)                                 /*CED001*/
             PGM        PARM(&STREAM &FAILED)                         /*CED001*/
 
/* Copyright statement definition */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Other declarations */
 
             DCL        VAR(&STREAM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BUTFPD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SAVEPD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILENM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREVFL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMBNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(80)
             DCL        VAR(&BUEN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST')
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7)
             DCL        VAR(&AOMEXP) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PDPLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FAILED) TYPE(*CHAR) LEN(1)               /*CED001*/
             DCL        VAR(&DTAQNM) TYPE(*CHAR) LEN(10) +
                          VALUE('EDBULKQ   ')                         /*CED001*/
             DCL        VAR(&DTAQLB) TYPE(*CHAR) LEN(10) +
                          VALUE('*LIBL     ')                         /*CED001*/
             DCL        VAR(&DTAQLN) TYPE(*DEC) LEN(5 0) VALUE(34)    /*CED001*/
             DCL        VAR(&DTAQ)   TYPE(*CHAR) LEN(34)              /*CED001*/
             DCL        VAR(&DTAQWT) TYPE(*DEC) LEN(5 0) VALUE(0)     /*CED001*/
             DCL        VAR(&MSGID)   TYPE(*CHAR) LEN(7)              /*CED001*/
             DCL        VAR(&MSGDTA)  TYPE(*CHAR) LEN(100)            /*CED001*/
             DCL        VAR(&MSGF)    TYPE(*CHAR) LEN(10)             /*CED001*/
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)             /*CED001*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
                                                                      /*CED001*/
 
/************DCLF       FILE(EDBUTFPD)                                /*CED001*/
             DCLF       FILE(EDFBUTPD)                                /*CED001*/
 
/* Global error monitor */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
 
             CHGJOB     SWS(00000000)
 
/* Copyright statement definition - at runtime */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/* Carry out transfer ONLY if I/F is active */
 
             CHGVAR     VAR(&RTNC) VALUE('*MSG   ')                   /*CED001*/
             CALL       PGM(AOMEXPR0) PARM(&RTNC &OPTN &AOMEXP)
 
             IF         COND(&RTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&BUEN) VALUE(%SUBSTRING(&AOMEXP 26 1))
 
             IF         COND(&BUEN *EQ 'N') THEN(GOTO CMDLBL(ENDCLPGM))
 
/* Component message */
 
/************CHGVAR     VAR(&MEM) VALUE('EDC0020 - ED Bulk Transfer + /*CED001*/
/************             - 1 OF 10 ')                                /*CED001*/
             IF         COND(&FAILED *NE 'Y') THEN(CHGVAR VAR(&MEM) +
                          VALUE('EDC0020 - ED Bulk Transfer -' +
                          *BCAT &STREAM *BCAT 'OF 10'))               /*CED001*/
             ELSE       CMD(CHGVAR VAR(&MEM) VALUE('EDC0020 - ED +
                          Failed Bulk Transfers'))                    /*CED001*/
 
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/************                                                         /*CED001*/
/**Override*list of files to copy depending on Stream */              /*CED001*/
/************                                                         /*CED001*/
/************CHGVAR     VAR(&BUTFPD) VALUE('EDBUT' *CAT &STREAM *CAT +/*CED001*/
/************             'PD')                                       /*CED001*/
/************                                                         /*CED001*/
/************OVRDBF     FILE(EDBUTFPD) TOFILE(&BUTFPD) SHARE(*NO)     /*CED001*/
/************                                                         /*CED001*/
/************CHGVAR     VAR(&SAVEPD) VALUE('EDSAV' *CAT &STREAM *CAT +/*CED001*/
/************             'PD')                                       /*CED001*/
/************                                                         /*CED001*/
/************OVRDBF     FILE(EDSAVEPD) TOFILE(&SAVEPD)                /*CED001*/
/************                                                         /*CED001*/
             OVRDBF     FILE(EDFBUTPD) SHARE(*NO)                     /*CED001*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
             CHGVAR     VAR(&PDPLIB) VALUE(&PREF *CAT 'DPLIB')
                                                                      /*CED001*/
/* Start Commitment Control for PF/EDSAVXPD                           /*CED001*/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/**********  STRCMTCTL  LCKLVL(*CS) DFTJRN(JEDC0010) OMTJRNE(*LUWID)  /*CED001*/
                                                               /*S01408 CPK009*/
             STRCMTCTL  LCKLVL(*CS) CMTSCOPE(*JOB) DFTJRN(JEDC0010) +
                          OMTJRNE(*LUWID)                       /*CED001CPK009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
/*                                                                      CCB009*/
/*  Start commitment control                                            CCB009*/
/*                                                                      CCB009*/
             STRCMTCTL  LCKLVL(*CS) CMTSCOPE(*JOB) DFTJRN(ICJRN) +
                          OMTJRNE(*LUWID)                             /*CCB009*/
             ENDDO                                                    /*CCB009*/
/*/COPY WNCPYSRC,EDC0020MP1                                          */
 
/* Delete Output file for DFPFD command */
 
LOOP1:
/************DLTF*******FILE(QTEMP/EDOUTFPD)                          /*118268*/
/************MONMSG*****MSGID(CPF2105)                                /*118268*/
 
/* Read a record from list of files */
 
             IF         COND(&FAILED *EQ 'Y') THEN(DO)                /*CED001*/
                                                                      /*CED001*/
             RCVF
             MONMSG     MSGID(CPF0864 CPF5264) EXEC(GOTO CMDLBL(FINAL))
 
             ENDDO                                                    /*CED001*/
             ELSE       CMD(DO)                                       /*CED001*/
                                                                      /*CED001*/
/* Receive File from DTAQ/EDBULKQ                                     /*CED001*/
                                                                      /*CED001*/
                 CALL       PGM(QRCVDTAQ) PARM(&DTAQNM &DTAQLB +
                             &DTAQLN &DTAQ &DTAQWT)                   /*CED001*/
                                                                      /*CED001*/
                 IF         COND(&DTAQLN *EQ 0) +
                             THEN(GOTO CMDLBL(FINAL))                 /*CED001*/
                                                                      /*CED001*/
                 CHGVAR     VAR(&EDTRFN) VALUE(%SST(&DTAQ  1 20))     /*CED001*/
                 CHGVAR     VAR(&EDSPPP) VALUE(%SST(&DTAQ 21 10))     /*CED001*/
                 CHGVAR     VAR(&EDSQCD) VALUE(%SST(&DTAQ 31  3))     /*CED001*/
                 CHGVAR     VAR(&EDEXFL) VALUE(%SST(&DTAQ 34  1))     /*CED001*/
                                                                      /*CED001*/
             ENDDO                                                    /*CED001*/
                                                                      /*CED001*/
/* If the name of the file to be transferred has changed then */
/* do a DSPFD to find out all the members in the file         */
/* If the name of the file starts with a * then this is a     */      /*117467*/
/* special case and the DSPFD bypassed                        */      /*117467*/
 
             CHGVAR     VAR(&FILENM) VALUE(%SUBSTRING(&EDTRFN 1 10))
 
/**********  IF         COND(&FILENM *NE &PREVFL) THEN(DO) */         /*117467*/
             IF         COND((&FILENM *NE &PREVFL) *AND +
                          (%SST(&FILENM 1 1) *NE '*')) THEN(DO)       /*117467*/
 
                ALCOBJ     OBJ((&FILENM *FILE *SHRRD)) WAIT(5)        /*CED001*/
                MONMSG     MSGID(CPF1002 CPF1085) EXEC(DO)            /*CED001*/
                    IF         COND(&FAILED *NE 'Y') THEN(DO)         /*CED001*/
                        CHGVAR     VAR(&PREVFL) VALUE(&FILENM)        /*CED001*/
                        GOTO       CMDLBL(LOOP1)                      /*CED001*/
                    ENDDO                                             /*CED001*/
                    ELSE       CMD(GOTO CMDLBL(ABNOR))                /*CED001*/
                ENDDO                                                 /*CED001*/
                DSPFD      FILE(&FILENM) TYPE(*MBR) OUTPUT(*OUTFILE) +
                             OUTFILE(QTEMP/EDOUTFPD)
 
/************   MONMSG     MSGID(CPF3012) EXEC(GOTO CMDLBL(ABNOR))    /*CED001*/
 
             ENDDO
 
/* If member name is ALL then set it to blanks so that all members */
/* are copied                                                      */
 
             CHGVAR     VAR(&MEMBNM) VALUE(%SUBSTRING(&EDTRFN 11 10))
 
/* If EDSPPP is not blank the call this program */                    /*101971*/
 
             IF         COND(&EDSPPP *EQ ' ') THEN(DO)                /*101971*/
/* Call ED0020 to write the header to the output member and copy */
/* the file.                                                     */
/* If a special case entry (ie the file name starts with a *) is */   /*117467*/
/* being processed, call EDC0005 instead of ED0020               */   /*117467*/
 
/************   CALL       PGM(ED0020) PARM(&PDPLIB &FILENM &MEMBNM + /*CED001*/
/************                &STREAM)                                 /*CED001*/
               IF         COND(%SST(&FILENM 1 1) *NE '*') THEN(DO)    /*117467*/
                 CALL       PGM(ED0020) PARM(&PDPLIB &FILENM &MEMBNM +
                             &EDSQCD &STREAM)                         /*CED001*/
               ENDDO                                                  /*117467*/
               ELSE       CMD(DO)                                     /*117467*/
                 IF         COND(&FILENM *EQ '** HALT **') THEN(DO)   /*117467*/
                   CALL       PGM(EDC0005) PARM(HALT EDHEADPD &MEMBNM +
                                EDBULKPD EDSAVXPD &EDTRFN)            /*117467*/
                   GOTO       CMDLBL(ERRORCHK)                        /*117467*/
                 ENDDO                                                /*117467*/
/*/COPY WNCPYSRC,EDC0020001                                          */
                 CALL       PGM(EDC0005) PARM(&FILENM EDHEADPD +
                              &MEMBNM EDBULKPD EDSAVXPD &EDTRFN)      /*117467*/
                 GOTO       CMDLBL(ERRORCHK)                          /*117467*/
               ENDDO                                                  /*117467*/
             ENDDO                                                    /*101971*/
/************IF         COND(&EDSPPP *NE ' ') THEN(CALL PGM(&EDSPPP) +/*CED001*/
/************             PARM(&PDPLIB &FILENM &MEMBNM &STREAM))101971/*CED001*/
/************IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +           /*CED001*/
/************             CMDLBL(ABNOR))                              /*CED001*/
/************IF         COND(&EDSPPP *NE ' ') THEN(DO)                /*117467*/
             IF         COND((&EDSPPP *NE ' ') *AND (%SST(&FILENM 1 +
                          1) *NE '*')) THEN(DO)                       /*117467*/
                 CALL       PGM(&EDSPPP) PARM(&PDPLIB &FILENM +
                             &MEMBNM &EDSQCD &STREAM)                 /*CED001*/
             ENDDO                                                    /*CED001*/
             DLCOBJ     OBJ((&FILENM *FILE *SHRRD))                   /*CED001*/
             MONMSG     MSGID(CPF0000)                                /*CED001*/
                                                                      /*CED001*/
 ERRORCHK:                                                            /*117467*/
/* Send Database Error                                                /*CED001*/
                                                                      /*CED001*/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)              /*CED001*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*CED001*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                        TOMSGQ(MOPERQ MRUNQ)                          /*CED001*/
                 MONMSG     MSGID(CPF0000 RPG0000 MCH0000)            /*CED001*/
                 GOTO       CMDLBL(ABNOR)                             /*CED001*/
             ENDDO                                                    /*CED001*/
 
/* Loop round to read next record from PF/EDBUTFPD */
 
             CHGVAR     VAR(&PREVFL) VALUE(&FILENM)
             GOTO       CMDLBL(LOOP1)
 
/* Normal termination */
 
FINAL:
             DLTOVR     FILE(*ALL)
             GOTO       CMDLBL(ENDCLPGM)
 
/* Abnormal termination */
 
ABNOR:
/************SNDPGMMSG  MSG('EDC0020 Midas ED Bulk Transfer +         /*CED001*/
/************             TERMINATED ABNORMALLY') TOMSGQ(*SYSOPR) +   /*CED001*/
/************             MSGTYPE(*INQ)                               /*CED001*/
                                                                      /*CED001*/
             RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID) MSGF(&MSGF) +
                          MSGFLIB(&MSGFLIB)                           /*CED001*/
             MONMSG     MSGID(CPF0000)                                /*CED001*/
                                                                      /*CED001*/
             IF         COND(&MSGID *NE '       ') THEN(DO)           /*CED001*/
                 SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                            MSGDTA(&MSGDTA) TOMSGQ(MOPERQ MRUNQ)      /*CED001*/
                 MONMSG     MSGID(CPF0000)                            /*CED001*/
                                                                      /*CED001*/
             ENDDO                                                    /*CED001*/
                                                                      /*CED001*/
             CHGVAR     VAR(&MEM) VALUE('EDC0020 - ED Failed to +
                          Transfer' *BCAT &FILENM)                    /*CED001*/
             IF         COND(&MEMBNM *NE ' ') THEN(CHGVAR VAR(&MEM) +
                          VALUE(&MEM *TCAT ' Member' *BCAT &MEMBNM))  /*CED001*/
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)                /*CED001*/
                                                                      /*CED001*/
             SNDPGMMSG  MSG('EDC0020 - ED Bulk Transfer TERMINATED +
                          ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)           /*CED001*/
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CHGJOB     SWS(XXXXXX11)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
ENDCLPGM:
             ROLLBACK                                                 /*CED001*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*CED001*/
             ENDCMTCTL                                                /*CED001*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*CED001*/
             ENDPGM
