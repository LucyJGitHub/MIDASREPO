/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MR Extract Postings')                           */
/*********************************************************************/
/*                                                                   */
/*       Midas - MidasPlus Reporting Module                          */
/*                                                                   */
/*       MRC0010 - Extract Postings                                  */
/*                                                                   */
/*       (c) Finastra International Limited 2004                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CAP204             Date 03Mar10              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BG18886            Date 28May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CMR001             Date 01Sep04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAP204  - Retail Account Transfer                           */
/*       BG18886 - Amend non-standard codes.                         */
/*       CMR001 - MidasPlus Reporting                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FILE)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2004')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('MRC0010 - Extract Postings') +
                          TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
 
             IF         COND(&FILE = 'A') THEN(DO)
             CLRPFM     FILE(MRPCMXPD) MBR(CURR)
             OVRDBF     FILE(MRPCMXPD) MBR(CURR)
             ENDDO
 
/* APOSTPD*/
             IF         COND(&FILE = 'A') THEN(DO)
             OVRDBF     FILE(APOSTPD) TOFILE(APOSTPD) SEQONLY(*YES 1000)
             OVRDBF     FILE(ACPO)    TOFILE(GECX2PD) SEQONLY(*YES 1000)
             CLRPFM     FILE(MRPOSTPD) MBR(APOSTPD)
             OVRDBF     FILE(MRPOSTPD) MBR(APOSTPD) SEQONLY(*YES 5000)
             ENDDO
/*GLACPHPD*/
             IF         COND(&FILE = 'G') THEN(DO)
             OVRDBF     FILE(APOSTPD) TOFILE(GLACPHPD) SEQONLY(*YES 1000)
             OVRDBF     FILE(ACPO)    TOFILE(GECX2PD) SEQONLY(*YES 1000)
             CLRPFM     FILE(MRPOSTPD) MBR(GLACPHPD)
             OVRDBF     FILE(MRPOSTPD) MBR(GLACPHPD) SEQONLY(*YES 5000)
             ENDDO
/*EODPOPD*/
             IF         COND(&FILE = 'E') THEN(DO)
             OVRDBF     FILE(APOSTPD) TOFILE(EODPOPD) SEQONLY(*YES 1000)
             OVRDBF     FILE(ACPO)    TOFILE(GECX2PD) SEQONLY(*YES 1000)
             CLRPFM     FILE(MRPOSTPD) MBR(EODPOPD)
             OVRDBF     FILE(MRPOSTPD) MBR(EODPOPD) SEQONLY(*YES 5000)
             ENDDO
/* ACPO1*/
             IF         COND(&FILE = '1') THEN(DO)
             OVRDBF     FILE(APOSTPD) TOFILE(GECX2PD) SEQONLY(*YES 1000)
/**********  OVRDBF     FILE(ACPO)    TOFILE(ACPO1 ) SEQONLY(*YES 1000)  */               /*CAP204*/
/**********  CLRPFM     FILE(MRPOSTPD)  MBR(ACPO1  )                     */               /*CAP204*/
/**********  OVRDBF     FILE(MRPOSTPD)  MBR(ACPO1  ) SEQONLY(*YES 5000)  */               /*CAP204*/
             OVRDBF     FILE(ACPO) TOFILE(GLACPML0) SEQONLY(*YES 1000)                    /*CAP204*/
             CLRPFM     FILE(MRPOSTPD) MBR(GLACPML0)                                      /*CAP204*/
             OVRDBF     FILE(MRPOSTPD) MBR(GLACPML0) SEQONLY(*YES 5000)                   /*CAP204*/
             ENDDO
/* ACPO2*/
             IF         COND(&FILE = '2') THEN(DO)
             OVRDBF     FILE(APOSTPD) TOFILE(GECX2PD) SEQONLY(*YES 1000)
             OVRDBF     FILE(ACPO)    TOFILE(ACPO2 ) SEQONLY(*YES 1000)
             CLRPFM     FILE(MRPOSTPD)  MBR(ACPO2  )
             OVRDBF     FILE(MRPOSTPD)  MBR(ACPO2  ) SEQONLY(*YES 5000)
             ENDDO
/* ACPO3*/
             IF         COND(&FILE = '3') THEN(DO)
             OVRDBF     FILE(APOSTPD) TOFILE(GECX2PD) SEQONLY(*YES 1000)
             OVRDBF     FILE(ACPO)    TOFILE(ACPO3 ) SEQONLY(*YES 1000)
             CLRPFM     FILE(MRPOSTPD)  MBR(ACPO3  )
             OVRDBF     FILE(MRPOSTPD)  MBR(ACPO3  ) SEQONLY(*YES 5000)
             ENDDO
/* ACPO4*/
             IF         COND(&FILE = '4') THEN(DO)
             OVRDBF     FILE(APOSTPD) TOFILE(GECX2PD) SEQONLY(*YES 1000)
             OVRDBF     FILE(ACPO)    TOFILE(ACPO4 ) SEQONLY(*YES 1000)
             CLRPFM     FILE(MRPOSTPD)  MBR(ACPO4  )
             OVRDBF     FILE(MRPOSTPD)  MBR(ACPO4  ) SEQONLY(*YES 5000)
             ENDDO
/* ACPO5*/
             IF         COND(&FILE = '5') THEN(DO)
             OVRDBF     FILE(APOSTPD) TOFILE(GECX2PD) SEQONLY(*YES 1000)
             OVRDBF     FILE(ACPO)    TOFILE(ACPO5 ) SEQONLY(*YES 1000)
             CLRPFM     FILE(MRPOSTPD)  MBR(ACPO5  )
             OVRDBF     FILE(MRPOSTPD)  MBR(ACPO5  ) SEQONLY(*YES 5000)
             ENDDO
 
 
/**********  IF         COND(&FILE *= 'A' *AND &FILE *= 'G' *AND +
                          &FILE *= 'E' *AND &FILE *= '1' *AND &FILE +
                          *= '2' *AND &FILE *= '3' *AND &FILE *= +
                          '4' *AND &FILE *= '5') THEN(DO)                             */ /*BG18886*/
             IF         COND(&FILE *NE 'A' *AND &FILE *NE 'G' *AND +
                          &FILE *NE 'E' *AND &FILE *NE '1' *AND +
                          &FILE *NE '2' *AND &FILE *NE '3' *AND +
                          &FILE *NE '4' *AND &FILE *NE '5') +
                          THEN(DO)                                                       /*BG18886*/
             CHGJOB SWS(XXXXXX11)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CALL       PGM(MR000010) PARM(&FILE)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(ENDP)
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MRC0010 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDPGM
