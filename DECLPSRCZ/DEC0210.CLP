/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DE Historic Trns Comparison + Selection Ctl')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0210 - Historic Trans Comparison and Selection Control   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 208221             Date 11Dec02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CDE002  *CREATE    Date 16May00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       208221 - Changes identified during alpha site               */
/*       CDE002 - Data Export - CCRM Revenue Analysis                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MNAME)
 
/*/COPY WNCPYSRC,DEC0210INT                                          */
 
             DCL        VAR(&MNAME) TYPE(*CHAR) LEN(4)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FHDC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('DEC0210 - Historic Trans Comparison & +
                          Selection Control') TOMSGQ(MRUNQ)
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB SWS(00000000)
 
/*/COPY WNCPYSRC,DEC0210MPS                                          */
 
             RTVDTAARA  DTAARA(DEEXTCTL (46 1)) RTNVAR(&FHDC)
 
             CLRPFM     FILE(DENTRANPD) MBR(&MNAME)
 
             OVRDBF     FILE(DENTRANPD) MBR(&MNAME) SHARE(*NO)
             OVRDBF     FILE(DEOTRANL1) MBR(&MNAME) SHARE(*NO)                           /*208221*/
 
             IF         COND(&FHDC *EQ 'Y') +
                        THEN(DO)
 
 
             OPNQRYF    FILE((DEHTRANPD &MNAME *ONLY) (DEOTRANPD +
                          &MNAME *ONLY)) OPTION(*INP) +
                          FORMAT(DENTRANPD) JFLD((DEOTRANPD/T#MOD +
                          DEHTRANPD/T#MOD) (DEOTRANPD/T#TREF +
                          DEHTRANPD/T#TREF) (DEOTRANPD/T#TRTP +
                          DEHTRANPD/T#TRTP) (DEOTRANPD/T#TRST +
                          DEHTRANPD/T#TRST) (DEOTRANPD/T#TDES +
                          DEHTRANPD/T#TDES) (DEOTRANPD/T#DDAT +
                          DEHTRANPD/T#DDAT) (DEOTRANPD/T#VDAT +
                          DEHTRANPD/T#VDAT) (DEOTRANPD/T#MDAT +
                          DEHTRANPD/T#MDAT) (DEOTRANPD/T#BRCA +
                          DEHTRANPD/T#BRCA) (DEOTRANPD/T#BOOK +
                          DEHTRANPD/T#BOOK) (DEOTRANPD/T#TPFC +
                          DEHTRANPD/T#TPFC) (DEOTRANPD/T#FPFC +
                          DEHTRANPD/T#FPFC) (DEOTRANPD/T#CPTY +
                          DEHTRANPD/T#CPTY) (DEOTRANPD/T#RCST +
                          DEHTRANPD/T#RCST) (DEOTRANPD/T#LICD +
                          DEHTRANPD/T#LICD) (DEOTRANPD/T#CNCD +
                          DEHTRANPD/T#CNCD) (DEOTRANPD/T#RCSI +
                          DEHTRANPD/T#RCSI) (DEOTRANPD/T#ISEI +
                          DEHTRANPD/T#ISEI) (DEOTRANPD/T#MKVL +
                          DEHTRANPD/T#MKVL) (DEOTRANPD/T#VCCY +
                          DEHTRANPD/T#VCCY) (DEOTRANPD/T#VCDP +
                          DEHTRANPD/T#VCDP) (DEOTRANPD/T#VALR +
                          DEHTRANPD/T#VALR) (DEOTRANPD/T#MATR +
                          DEHTRANPD/T#MATR) (DEOTRANPD/T#RLDO +
                          DEHTRANPD/T#RLDO) (DEOTRANPD/T#ACTN +
                          DEHTRANPD/T#ACTN)) JDFTVAL(*ONLYDFT) +
                          MAPFLD((T#MOD 'DEHTRANPD/T#MOD') (T#TREF +
                          'DEHTRANPD/T#TREF') (T#TRTP +
                          'DEHTRANPD/T#TRTP') (T#TRST +
                          'DEHTRANPD/T#TRST') (T#TDES +
                          'DEHTRANPD/T#TDES') (T#DDAT +
                          'DEHTRANPD/T#DDAT') (T#VDAT +
                          'DEHTRANPD/T#VDAT') (T#MDAT +
                          'DEHTRANPD/T#MDAT') (T#BRCA +
                          'DEHTRANPD/T#BRCA') (T#BOOK +
                          'DEHTRANPD/T#BOOK') (T#TPFC +
                          'DEHTRANPD/T#TPFC') (T#FPFC +
                          'DEHTRANPD/T#FPFC') (T#CPTY +
                          'DEHTRANPD/T#CPTY') (T#RCST +
                          'DEHTRANPD/T#RCST') (T#LICD +
                          'DEHTRANPD/T#LICD') (T#CNCD +
                          'DEHTRANPD/T#CNCD') (T#RCSI +
                          'DEHTRANPD/T#RCSI') (T#ISEI +
                          'DEHTRANPD/T#ISEI') (T#MKVL +
                          'DEHTRANPD/T#MKVL') (T#VCCY +
                          'DEHTRANPD/T#VCCY') (T#VCDP +
                          'DEHTRANPD/T#VCDP') (T#VALR +
                          'DEHTRANPD/T#VALR') (T#MATR +
                          'DEHTRANPD/T#MATR') (T#RLDO +
                          'DEHTRANPD/T#RLDO') (T#ACTN +
                          'DEHTRANPD/T#ACTN') (T#TMST +
                          'DEHTRANPD/T#TMST') (T#FEEC +
                          'DEHTRANPD/T#FEEC') (T#CAFE +
                          'DEHTRANPD/T#CAFE') (T#NBRF +
                          'DEHTRANPD/T#NBRF') (T#NBSC +
                          'DEHTRANPD/T#NBSC') (T#NSRF +
                          'DEHTRANPD/T#NSRF') (T#NSSC +
                          'DEHTRANPD/T#NSSC')) OPNID(DEHTRANPD)
 
             CPYFRMQRYF FROMOPNID(DEHTRANPD) TOFILE(QTEMP/DEHTRANPD) +
                          TOMBR(&MNAME) MBROPT(*ADD) CRTFILE(*YES)
 
             OVRDBF     FILE(DEHTRANPD) TOFILE(QTEMP/DEHTRANPD) +
                          MBR(&MNAME) SHARE(*NO)
 
             CALL       PGM(DE0210) PARM(&RTCD &ERMS)
 
             DLTF       QTEMP/DEHTRANPD
 
/**          CLOF       OPNID(DENTRANPD)                        **/
             CLOF       OPNID(DEHTRANPD)
/**          CLOF       OPNID(DEOTRANPD)                        **/
             ENDDO
 
             IF         COND(&FHDC *EQ ' ') +
                        THEN(DO)
 
             OVRDBF     FILE(DEHTRANPD) MBR(&MNAME) SHARE(*NO)
 
             CALL       PGM(DE0210) PARM(&RTCD &ERMS)
             ENDDO
 
             DLTOVR *ALL
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
              IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0210 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
              ENDDO
 
              IF         COND(&JOBTYPE = '1') THEN(DO)
               ROLLBACK
               SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
               GOTO       CMDLBL(END)
              ENDDO
             ENDDO
 
/*/COPY WNCPYSRC,DEC0210MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DEC0210ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0210 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
               GOTO       CMDLBL(END)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
               GOTO       CMDLBL(END)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,DEC0210END                                          */
 
 
             ENDPGM
