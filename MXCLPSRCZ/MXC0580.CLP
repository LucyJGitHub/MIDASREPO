/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MX Balance accumulation - GL module')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Meridian Export Module                              */
/*                                                                   */
/*       MXC0580 - Balance Accumulation - GENERAL LEDGER Module      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD022103           Date 28Aug13              */
/*                      AR1097467          Date 17Apr13              */
/*                      AR1097467          Date 08Apr13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      187908             Date 20Dec00              */
/*                      CMX003             Date 05Nov00              */
/*                      CMX001  *CREATE    Data 01Jan00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD022103 - MXC0580 Performance Improvement                  */
/*       AR1097467B - Expected 15% COB run optimization not met      */
/*       AR1097467 - Expected 15% COB run optimization not met       */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       187908 - Truncation on total field BCEQ in CPYFRMQRYF       */
/*       CMX003 - Meridian Export Enhancements - Phase 2             */
/*       CMX001 - Meridian Export                                    */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,MXC0580INT                                          */
 
             DCL        VAR(&DTAG) TYPE(*CHAR) LEN( 4)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN( 7)
             DCL        VAR(&ERMS) TYPE(*CHAR) LEN(30)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB SWS(00000000)
 
/*/COPY WNCPYSRC,MXC0580MPS                                          */
 
 
             CHGVAR     VAR(&DTAG) VALUE(ACCT)
 
             CLRPFM     FILE(MXBLGLPD)
 
/**********  OVRDBF     FILE(MXBLGLPD) TOFILE(MXBLGL2PD)             */     /*AR1097467 AR1097467B*/
                                                                                       /*AR1097467*/
             CALL       PGM(MXBLACGL) PARM(&RTCD &ERMS &DTAG)
 
             DLTOVR *ALL
 
/**********  CALL       CBC022001 PARM('MXBLGLPD' ' ' '*RMV' ' ')    */     /*AR1097467 AR1097467B*/
                                                                                       /*AR1097467*/
/**Copy*MXBLGL2PD*to*MXBLGLPD*to*arrange*by*keys**/                         /*AR1097467 AR1097467B*/
                                                                                       /*AR1097467*/
/**********  CPYF       FROMFILE(MXBLGL2PD) TOFILE(MXBLGLPD) +
                          MBROPT(*REPLACE)                           */     /*AR1097467 AR1097467B*/
                                                                                       /*AR1097467*/
/**********  CALL       CBC022001 PARM('MXBLGLPD' ' ' '*ADD' ' ')    */     /*AR1097467 AR1097467B*/
                                                                                       /*AR1097467*/
/**********  CLRPFM     FILE(MXBLGL2PD)                              */     /*AR1097467 AR1097467B*/
                                                                                       /*AR1097467*/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0580 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               GOTO       CMDLBL(END)
             ENDDO
 
/* Start of CMX003 */
 
/* Build the Customer Posting Summary file from this month's events */
 
/************OPNQRYF    FILE((MXMEGLPD) (SDACODPD)) FORMAT(MXCPSSPD)+*/                   /*187908*/
/************             QRYSLT('(A5ACTY = "R" & DECATC = "11") +   */                   /*187908*/
/************             *OR               (A5ACTY = "R"  & DECATC +*/                   /*187908*/
/************             = "12")') KEYFLD((CNUM) (TRATA)) +         */                   /*187908*/
/************             JFLD((SDACODPD/A5ACCD MAPACOD)) +          */                   /*187908*/
/************             GRPFLD(CNUM TRATA) MAPFLD((MAPACOD +       */                   /*187908*/
/************             'MXMEGLPD/ACOD' *CHAR 4) (BCEQ +           */                   /*187908*/
/************             '%SUM(MXMEGLPD/BCEQ)') (CNTPST +           */                   /*187908*/
/************             '%SUM(MXMEGLPD/CNTPST)'))                  */                   /*187908*/
 
/**********  OPNQRYF    FILE((MXMEGLPD) (SDACODPD)) FORMAT(MXCPSSPD) + */      /*187908*/ /*CGL029*/
/**********               QRYSLT('(A5ACTY = "R" & DECATC = "11") +     */      /*187908*/ /*CGL029*/
/**********               *OR            (A5ACTY = "R"  & DECATC = +   */      /*187908*/ /*CGL029*/
/**********               "12")') KEYFLD((CNUM) (TRATA)) +             */      /*187908*/ /*CGL029*/
/**********               JFLD((SDACODPD/A5ACCD MAPACOD)) +            */      /*187908*/ /*CGL029*/
/**********               GRPFLD(CNUM TRATA) MAPFLD((MAPACOD +         */      /*187908*/ /*CGL029*/
/**********               'MXMEGLPD/ACOD' *CHAR 10) (TBCEQ +           */      /*187908*/ /*CGL029*/
/**********               'MXMEGLPD/ACOD' *CHAR 4) (TBCEQ +            */      /*187908*/ /*CGL029*/
/**********               '%SUM(MXMEGLPD/BCEQ)') (TCNTPS +             */      /*187908*/ /*CGL029*/
/**********               '%SUM(MXMEGLPD/CNTPST)'))                    */      /*187908*/ /*CGL029*/
 
/**********  OPNQRYF    FILE((MXMEGLPD) (SDACODPD)) FORMAT(MXCPSSPD) +*/                /*MD022103*/
/**********               QRYSLT('(A5ACTY = "R" & DECATC = "11") + */                   /*MD022103*/
/**********               *OR            (A5ACTY = "R"  & DECATC = +*/                  /*MD022103*/
/**********               "12")') KEYFLD((CNUM) (TRATA)) +         */                   /*MD022103*/
/**********               JFLD((SDACODPD/A5ACCD MAPACOD)) +        */                   /*MD022103*/
/**********               GRPFLD(CNUM TRATA) MAPFLD((MAPACOD +     */                   /*MD022103*/
/**********               'MXMEGLPD/ACOD' *CHAR 10) (TBCEQ +       */                   /*MD022103*/
/**********               '%SUM(MXMEGLPD/BCEQ)') (TCNTPS +         */                   /*MD022103*/
/**********               '%SUM(MXMEGLPD/CNTPST)'))                */            /*CGL028 MD022103*/
/*******************************************************************/                   /*MD022103*/
/**********  CPYFRMQRYF FROMOPNID(MXMEGLPD) TOFILE(MXCPSSPD) +     */                   /*MD022103*/
/**********               MBROPT(*REPLACE) FMTOPT(*NOCHK)          */                   /*MD022103*/
 
/* End of CMX003 */
 
/*/COPY WNCPYSRC,MXC0580MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,MXC0580ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            MXC0580 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,MXC0580END                                          */
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ENDPGM
