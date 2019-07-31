/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas DL Mismatched fiduc. deposits & loans report')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC2104 - Mismatched Fiduciary Deposits and Loans report    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Phase:  I/C  on request or COB                              */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      BG18886            Date 02Jun08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CDL006  *CREATE    Date 26Apr99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       BG18886 - Amend non-standard codes.                         */
/*       CDL006 - Dealing Fiduciary.                                 */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&RSEQ &RLEV &RENT)
 
/* Declare variables                                               */
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* RCF Sequence Number                                             */
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
 
/* RCF Level Flag                                                  */
 
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
 
/* RCF Entity Code (ALL/COMP/BCH)                                  */
 
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&QRYSLT) TYPE(*CHAR) LEN(256)
/**********  DCL        VAR(&MPHAS)  TYPE(*CHAR) LEN(1)                                */ /*CCB020*/
             DCL        VAR(&MPHAS)  TYPE(*CHAR) LEN(4)                                   /*CCB020*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)
 
/* Global monitor message                                          */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             SNDPGMMSG  MSG('SWC8007 - Mismatched Fiduciary Deposits & Loans +
                          Report') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
             CHGJOB     SWS(XXXXXX00)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             RTVJOBA    TYPE(&JOBTYPE)
 
/* Select Placing records                                          */
 
             CHGVAR     VAR(&QRYSLT) VALUE('DTYP *EQ %VALUES("FL" +
                          "DP" "LP") *AND RECI *EQ "D"')
             OVRDBF     FILE(DLDPLAPD) TOFILE(DEALSDC) SHARE(*YES)
             OPNQRYF    FILE(DEALSDC) FORMAT(DLDPLAPD) +
                          QRYSLT(&QRYSLT) KEYFLD((DLNO)) TYPE(*PERM)
             DLTOVR     FILE(DLDPLAPD)
             CPYFRMQRYF FROMOPNID(DEALSDC) TOFILE(DLDPLAPD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             CLOF       OPNID(DEALSDC)
 
/* Select Taking records                                           */
 
             CHGVAR     VAR(&QRYSLT) VALUE('DTYP *EQ %VALUES("FT" +
                          "DT" "LT") *AND RECI *EQ "D"')
             OVRDBF     FILE(DLDTAKPD) TOFILE(DEALSDC) SHARE(*YES)
             OPNQRYF    FILE(DEALSDC) FORMAT(DLDTAKPD) +
                          QRYSLT(&QRYSLT) KEYFLD((LNKDN) (DLNO))
             DLTOVR     FILE(DLDTAKPD)
             CPYFRMQRYF FROMOPNID(DEALSDC) TOFILE(DLDTAKPD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             CLOF       OPNID(DEALSDC)
 
/* Select Amendment records, only during Input Cycle.              */
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                   */ /*CCB020*/
             CALL       PGM(CBC001001) PARM(&MPHAS)                                       /*CCB020*/
/**********  IF*********COND(&MPHAS**=*'A')*THEN(GOTO*CMDLBL(CALL))*/ /*BG18886*/
/**********  IF         COND(&MPHAS *NE 'A') THEN(GOTO CMDLBL(CALL))           */ /*BG18886 CCB020*/
             IF         COND(&MPHAS *EQ '*YES') THEN(GOTO CMDLBL(CALL))                   /*CCB020*/
 
             CHGVAR     VAR(&QRYSLT) VALUE('AMTP *EQ %VALUES( "PI"  +
                          "PD" ) *AND RECI *EQ "D" *AND DTYP *EQ +
                          %VALUES("DT" "LT" "DP" "LP")')
             OVRDBF     FILE(DLDDAMPD) TOFILE(DEAMSDI) SHARE(*YES)
             OPNQRYF    FILE(DEAMSDI) FORMAT(DLDDAMPD) +
                          QRYSLT(&QRYSLT) KEYFLD((DLNO) (VDAT) (DASN))
             DLTOVR     FILE(DLDDAMPD)
             CPYFRMQRYF FROMOPNID(DEAMSDI) TOFILE(DLDDAMPD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
             CLOF       OPNID(DEAMSDI)
 
/* Call program                                                    */
 
CALL:        CALL DL2104 PARM(&RSEQ &RLEV &RENT)
 
             DLTOVR     FILE(*ALL)
 
/* Database error processing                                       */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination - batch job                                */
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DLC2104 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
