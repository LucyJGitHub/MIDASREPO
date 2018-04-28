/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Loan Manager interface branch job')          */
/*********************************************************************/
/*                                                                   */
/*  Midas   - Customer Lending Module                                */
/*                                                                   */
/*  LEC2010A - Lending PC INTERFACE CONTROL (I/C)                    */
/*                                                                   */
/*  Function: To call the Lending PC Interface process LE2010        */
/*            during input cycle initiation.                         */
/*                                                                   */
/*  Calls:    LE2010                                                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*  Last Amend No. CLE134            Date  01Aug12                   */
/*  Prev Amend No. CCB020            Date  06Aug12                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                 CLE038            Date  11May04                   */
/*                 221254            Date  10Sep03                   */
/*                 219608            Date  14Jul03                   */
/*                 216709            Date  07Apr03                   */
/* Midas Release 4.01.03 --------------------------------------------*/
/*                 205772            Date  09Jan03                  */
/*                 203634            Date  09Jan03                  */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                 203561            Date  17Jun02                   */
/* Midas Release 4.01 -----------------------------------------------*/
/*                 200600            DATE  11Jan02                  */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                 191475            DATE  02Nov01                   */
/*                 193083            DATE  22JUN01                   */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                 124161            DATE  09OCT97                  */
/*                 120134            DATE  04JUL97                  */
/*                 CLE004  *CREATE   DATE  11MAY97                  */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*  CLE134 - Past Due Call Loan Processing (Recompile)               */
/*  CCB020 - COB Restructure - Secondary COB Infrastructure         */
/*  CLE038 - Lending Enhancement for Nordea: Allocation by Amount   */
/*  221254 - Job was looping due to unmonitored statements          */
/*           after the abnor label                                  */
/*  219608 - Amendment of Settlement Allocations needs 'before'     */
/*           image to ensure the right allocations are reversed.    */
/*  216709 - Do not send job shutdown message to Loan Manager if    */
/*           phase is not 'A'                                       */
/*  205772 - Override LEIFEELX to LEIFEEL2.                         */
/*  203634 - Override needed on LEFEEDL1 to avoid commitment        */
/*           control problems.                                      */
/*  200600 - Ensure LEC2010xxx data area is reset at termination    */
/*  203561 - Send status messages via new program LEC2017 to control */
/*           changes of status within Loan Manager. Enable stopping */
/*           and starting of interface jobs by branch using LMxxx   */
/*           data area (new)                                        */
/*  191475 - Overide LEFCAMSQ to LEFCAML3 and prevent the           */
/*           LEC2010xxx data area from being deleted at jobend      */
/*  193083 - Allocate LEC2010xxx data area so other jobs can check  */
/*           if this one is still running                           */
/*  124161 - Program loops trying to delete a non existing data area*/
/*  120134 - Override needed on loams to prevent cpf4293.           */
/*  CLE004 - Customer Lending Enhancements - Syndications.          */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&SERV &BRCD)
 
             DCL        VAR(&SERV) TYPE(*CHAR) LEN(3)
             DCL        VAR(&BRCD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DTAARA) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&LMDTAARA) TYPE(*CHAR) LEN(5) VALUE(' ')                      /*203561*/
             DCL        VAR(&P#RTCD) TYPE(*CHAR) LEN(7)                                   /*203561*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*080941*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)
/**********  DCL        VAR(&PHASE) TYPE(*CHAR) LEN(1)                          */ /*216709 CCB020*/
             DCL        VAR(&COBST) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&JOBID) TYPE(*CHAR) LEN(10)                                   /*219608*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('xxDMLIB')                                                /*219608*/
             DCL        VAR(&DVLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('xxDVLIB')                                                /*219608*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                                   /*219608*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*219608*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7) VALUE('*FREE')                     /*219608*/
             DCL        VAR(&PTYPE) TYPE(*CHAR) LEN(4)                                    /*219608*/
             DCL        VAR(&PLNRF) TYPE(*CHAR) LEN(6)                                    /*219608*/
             DCL        VAR(&PVDAT) TYPE(*CHAR) LEN(5)                                    /*219608*/
             DCL        VAR(&PLASN) TYPE(*CHAR) LEN(3)                                    /*219608*/
             DCL        VAR(&PCNUM) TYPE(*CHAR) LEN(6)                                    /*219608*/
             DCL        VAR(&PFACL) TYPE(*CHAR) LEN(5)                                    /*219608*/
             DCL        VAR(&PFSEQ) TYPE(*CHAR) LEN(2)                                    /*219608*/
             DCL        VAR(&PPYRC) TYPE(*CHAR) LEN(1)                                    /*219608*/
/**********  DCL        VAR(&DSSDY) TYPE(*CHAR) LEN(765)            */             /*219608 CLE038*/
             DCL        VAR(&DSSDY) TYPE(*CHAR) LEN(800)                                  /*CLE038*/
 
/**  Global Monitor Message                                         */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&DTAARA) VALUE('LEC2010' *CAT +
                          &SERV)
/************ALCOBJ     OBJ((&DTAARA *DTAARA *SHRRD))               */         /*193083*/ /*203561*/
/************ALCOBJ     OBJ((&DTAARA *DTAARA *SHRRD)) WAIT(0)       */         /*203561*/ /*221254*/
             CHGVAR     VAR(&LMDTAARA) VALUE('LM' *CAT &SERV)                             /*203561*/
             ALCOBJ     OBJ((&DTAARA *DTAARA *SHRRD)) WAIT(0)                             /*221254*/
 
             SNDPGMMSG  MSG('LEC2010A - Customer Lending PC +
                          Interface for server' *BCAT &SERV ) +
                          TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
 
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
 
             CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *CAT 'DPLIB')
 
             CRTDUPOBJ  OBJ(LEBRMSPD) FROMLIB(&DPLIB) +
                          OBJTYPE(*FILE) TOLIB(QTEMP) DATA(*NO)
 
             OVRDBF     FILE(LEBRMSPD) TOFILE(QTEMP/LEBRMSPD)
             OVRDBF     FILE(LEFCAMSQ) TOFILE(LEFCAML3) SHARE(*NO)                        /*191475*/
 
             OVRDBF     FILE(LOAMD) TOFILE(LOAMS) SHARE(*NO)
             OVRDBF     FILE(LOAMS) SHARE(*NO)                        /*120134*/
             OVRDBF     FILE(LEFEEDL1) SHARE(*NO)                                         /*203634*/
             OVRDBF     FILE(LEIFEELX) TOFILE(LEIFEEL2) SHARE(*NO)                        /*205772*/
                                                                                          /*219608*/
/* Create temporary file to hold 'before' image of LESTALPD */                            /*219608*/
             CPYF       FROMFILE(LEBSTLPD) TOFILE(QTEMP/LEBSTLPD) +
                          CRTFILE(*YES)                                                   /*219608*/
             MONMSG     MSGID(CPF2863 CPF2817) EXEC(DO)                                   /*219608*/
                        CLRPFM FILE(QTEMP/LEBSTLPD)                                       /*219608*/
             GOTO       CMDLBL(FILEND)         /* File already exists                     /*219608*/
                        ENDDO                                                             /*219608*/
                                                                                          /*219608*/
                                                                                          /*219608*/
/* Logical files LEBSTLL3 & LEBSTLL4 need to be based over the copy                       /*219608*/
/* of LEBSTLPD which was just created in QTEMP. This is achieved                          /*219608*/
/* by CRTDUPOBJ of LF to QTEMP (called 'job name' to ensure                               /*219608*/
/* uniqueness), MOVOBJ to xxDMLIB, CRTDUPOBJ back to QTEMP.                               /*219608*/
 
             RTVJOBA    JOB(&JOBID)                                                       /*219608*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                              /*219608*/
             CHGVAR     VAR(%SUBSTRING(&DMLIB 1 2)) VALUE(&PREFIX)                        /*219608*/
             CHGVAR     VAR(%SUBSTRING(&DVLIB 1 2)) VALUE(&PREFIX)                        /*219608*/
 
/* Create Logical file LEBSTLL3:                                                          /*219608*/
             CRTDUPOBJ  OBJ(LEBSTLL3) FROMLIB(&DVLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(&JOBID)                                     /*219608*/
             MONMSG     MSGID(CPF2130 CPD2104)                                            /*219608*/
 
             MOVOBJ     OBJ(&JOBID) OBJTYPE(*FILE) TOLIB(&DMLIB)                          /*219608*/
             MONMSG     MSGID(CPF2135)                                                    /*219608*/
                                                                                          /*219608*/
             CRTDUPOBJ  OBJ(&JOBID) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(LEBSTLL3)                                   /*219608*/
             MONMSG     MSGID(CPF2130 CPD2104)                                            /*219608*/
                                                                                          /*219608*/
             DLTF       FILE(&DMLIB/&JOBID)                                               /*219608*/
/*                                                                                        /*219608*/
/* Create Logical file LEBSTLL4:                                                          /*219608*/
             CRTDUPOBJ  OBJ(LEBSTLL4) FROMLIB(&DVLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(&JOBID)                                     /*219608*/
             MONMSG     MSGID(CPF2130 CPD2104)                                            /*219608*/
                                                                                          /*219608*/
             MOVOBJ     OBJ(&JOBID) OBJTYPE(*FILE) TOLIB(&DMLIB)                          /*219608*/
             MONMSG     MSGID(CPF2135)                                                    /*219608*/
                                                                                          /*219608*/
             CRTDUPOBJ  OBJ(&JOBID) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) NEWOBJ(LEBSTLL4)                                   /*219608*/
             MONMSG     MSGID(CPF2130 CPD2104)                                            /*219608*/
             DLTF       FILE(&DMLIB/&JOBID)                                               /*219608*/
                                                                                          /*219608*/
FILEND:                                                                                   /*219608*/
             OVRDBF     FILE(LEBSTLPD) TOFILE(QTEMP/LEBSTLPD) +
                          SHARE(*YES)                                                     /*219608*/
             OVRDBF     FILE(LEBSTLL3) TOFILE(QTEMP/LEBSTLL3) +
                          SHARE(*YES)                                                     /*219608*/
             OVRDBF     FILE(LEBSTLL4) TOFILE(QTEMP/LEBSTLL4) +
                          SHARE(*YES)                                                     /*219608*/
                                                                                          /*219608*/
/**/                                                                                      /*203561*/
/** Send message to Loan Manager to indicate that the Loan Manager  */                    /*203561*/
/** Interface job has started                                       */                    /*203561*/
/**/                                                                                      /*203561*/
             CALL       PGM(LEC2017) PARM(&P#RTCD 'STRI' &SERV &BRCD)                     /*203561*/
             IF         COND(%SWITCH(XXXXXX11) *OR (&P#RTCD *NE +
                          '*SENT')) THEN(GOTO CMDLBL(ABNOR))                              /*203561*/
/**/                                                                                      /*203561*/
/** Update LM Branch data area with last message sent               */                    /*203561*/
/**/                                                                                      /*203561*/
             CHGDTAARA  DTAARA(&LMDTAARA (1 4)) VALUE('STRI')
/**/                                                                                      /*203561*/
/** Update LM Branch data area with Interface Active flag           */                    /*203561*/
/**/                                                                                      /*203561*/
             CHGDTAARA  DTAARA(&LMDTAARA (6 1)) VALUE('Y')                                /*203561*/
 
             CALL       PGM(LE2010) PARM(&SERV &BRCD)
 
             ENDCMTCTL
 
             IF         COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
 
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*080941*/
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))            /*080941*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*080941*/
 
             ENDDO
 
             GOTO       CMDLBL(END)
 
/*     Abnormal termination                                          */
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                    /*221254*/
             SNDPGMMSG  MSG('LEC2010A - Lending PC Interface has +
                          ENDED ABNORMALLY for server' *BCAT +
                          &SERV) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                    /*221254*/
 
/*     Normal termination                                            */
 END:
/************DLTDTAARA  DTAARA(&DTAARA) */                                                /*191475*/
/************MONMSG     MSGID(CPF0000 MCH0000 RPG0000) */                      /*124161*/ /*191475*/
/**/                                                                                      /*203561*/
/** Send message to Loan Manager to indicate that the Loan Manager  */                    /*203561*/
/** Interface job has ended                                         */                    /*203561*/
/**/                                                                                      /*203561*/
/**********  RTVDTAARA  DTAARA(MPHAS *ALL) RTNVAR(&PHASE)                       */ /*216709 CCB020*/
             CALL       PGM(CCB001001) PARM(&COBST)                                       /*CCB020*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                    /*221254*/
/**********  IF         COND(&PHASE *EQ 'A') THEN(DO)                           */ /*216709 CCB020*/
             IF         COND(&COBST *EQ '*NO') THEN(DO)                                   /*CCB020*/
             CALL       PGM(LEC2017) PARM(&P#RTCD 'ENDI' &SERV &BRCD)                     /*203561*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                    /*203561*/
             ENDDO                                                                        /*216709*/
/**/                                                                                      /*203561*/
/** Update LM Branch data area with last message sent               */                    /*203561*/
/**/                                                                                      /*203561*/
             CHGDTAARA  DTAARA(&LMDTAARA (1 4)) VALUE('ENDI')
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                    /*203561*/
/**/                                                                                      /*203561*/
/** Update LM Branch data area with Interface job status            */                    /*203561*/
/**/                                                                                      /*203561*/
             CHGDTAARA  DTAARA(&LMDTAARA (6 1)) VALUE('N')                                /*203561*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                    /*203561*/
                                                                                          /*203561*/
/************DLCOBJ     OBJ((&DTAARA *DTAARA *SHRRD)) */                       /*200600*/ /*221254*/
/************MONMSG     MSGID(CPF0000)                */                       /*200600*/ /*221254*/
/************CHGDTAARA  DTAARA(&DTAARA) VALUE('N')    */                       /*200600*/ /*221254*/
/************MONMSG     MSGID(CPF0000)                */                       /*200600*/ /*221254*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
                                                                                          /*219608*/
/* Close file LEBSTLPD on access object AOBSTLR0 using Option '*FREE':                    /*219608*/
             CALL       PGM(AOBSTLR0) PARM(&PRTCD &POPTN &PTYPE +
                          &PLNRF &PVDAT &PLASN &PCNUM &PFACL +
                          &PFSEQ &PPYRC &DSSDY)                                           /*219608*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                    /*221254*/
                                                                                          /*219608*/
                                                                                          /*219608*/
             DLTOVR     FILE(LEBSTLPD)                                                    /*219608*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                    /*221254*/
             DLTOVR     FILE(LEBSTLL3)                                                    /*219608*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                    /*221254*/
             DLTOVR     FILE(LEBSTLL4)                                                    /*219608*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                    /*221254*/
                                                                                          /*219608*/
             DLTF     FILE(QTEMP/LEBSTLL3)                                                /*221254*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                    /*221254*/
             DLTF     FILE(QTEMP/LEBSTLL4)                                                /*221254*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                    /*221254*/
             DLTF     FILE(QTEMP/LEBSTLPD)                                                /*221254*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                    /*221254*/
             DLTF     FILE(QTEMP/LEBRMSPD)                                                /*221254*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)                                    /*221254*/
 
             CHGDTAARA  DTAARA(&DTAARA) VALUE('N')                                        /*221254*/
             MONMSG     MSGID(CPF0000)                                                    /*221254*/
 
 /* The deallocate should be the last thing the program does to ensure that only one      /*221254*/
 /* job can ever run at once                                                              /*221254*/
             DLCOBJ     OBJ((&DTAARA *DTAARA *SHRRD))                                     /*221254*/
             MONMSG     MSGID(CPF0000)                                                    /*221254*/
 
             ENDPGM
