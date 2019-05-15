/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI *  TEXT('Midas UT Change ownership and authority')             */
/*E*I****PGM(UTC0360)****VLDCKR(UTC0360VC)**MSGF(QCPFMSG)*************/ /*             */ /*250022*/
/*EXI    PGM(UTC0360)    VLDCKR(UTC0360VC)  MSGF(UTMSGF)             */                   /*250022*/
/*EXI    HLPPNLGRP(CHGOWNAUT)  HLPID(*CMD)                           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       CHGOWNAUT - Change ownership and authority of objects and   */
/*                   Libraries                                       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      250022             Date 07Aug07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CUP015             Date 18Jun01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUT001  *CREATE    Date 23JUL98              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*       250022 - Enhancements to the CHGOWNAUT utility.  Add checks */
/*                to the command.                                    */
/*       CUP015 - Add *MODULE and *SRVPGM to object types. Also drop */
/*                 *DOC and *FLR as these will not work.             */
/*       CUT001 - Bring CHGOWNAUT command and associated programs    */
/*                into core midas                                    */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Change object ownership & auts')
             PARM       KWD(OBJ) TYPE(QUAL1) MIN(1) +
                          PROMPT('Object:')
/************PARM       KWD(OBJTYPE) TYPE(*CHAR) LEN(10) RSTD(*YES) +                  */ /*CUP015*/
/************             VALUES(*ALL *AUTL *CLS *CMD *DEVD *DOC +                     */ /*CUP015*/
/************             *DTAARA *DTADCT *DTAQ *FILE *FLR *JOBD +                     */ /*CUP015*/
/************             *JOBQ *JRN *JRNRCV *LIB *MENU *MSGF *MSGQ +                  */ /*CUP015*/
/************             *OUTQ *PNLGRP *PGM *QRYDFN *SBSD *TBL +                      */ /*CUP015*/
/************             *USRPRF) MIN(1) PROMPT('Object type:')                       */ /*CUP015*/
             PARM       KWD(OBJTYPE) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          VALUES(*ALL *AUTL *CLS *CMD *DEVD *DTAARA +
                          *DTADCT *DTAQ *FILE *JOBD *JOBQ *JRN +
                          *JRNRCV *LIB *MENU *MODULE *MSGF *MSGQ +
                          *OUTQ *PNLGRP *PGM *QRYDFN *SBSD *SRVPGM +
                          *TBL *USRPRF) MIN(1) PROMPT('Object type:')                     /*CUP015*/
             PARM       KWD(NEWOWN) TYPE(*NAME) LEN(10) MIN(0) +
                          PROMPT('New owner:')
             PARM       KWD(CUROWNAUT) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*REVOKE) VALUES(*REVOKE *SAME) MIN(0) +
                          PROMPT('Current owner authority:')
             PARM       KWD(ALLUSER) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(Y) VALUES(Y N) PROMPT('Remove other +
                          users authority?:')
             PARM       KWD(PUBAUT) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*USE) VALUES(*SAME *AUTL *ALL *CHANGE +
                          *USE *EXCLUDE) MIN(0) PROMPT('*PUBLIC +
                          authority:')
             PARM       KWD(AUTL) TYPE(*NAME) LEN(10) DFT(*SAME) +
                          SPCVAL((*REVOKE) (*SAME)) MIN(0) +
                          PROMPT('Authorisation list:')
             PARM       KWD(CHGLIB) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT(Y) VALUES(Y N) PROMPT('Change library +
                          ?:')
 
             PARM       KWD(OVRLIBVLD) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES) MIN(0) +
                          PMTCTL(*PMTRQS) PROMPT('Override library +
                          validation')
 
             PARM       KWD(LOG) TYPE(*CHAR) LEN(4) CONSTANT(*NO) +
                          RSTD(*YES) VALUES(*NO) SPCVAL((*NO)) MIN(1)
 
 QUAL1:      QUAL       TYPE(*GENERIC) LEN(10) SPCVAL((*ALL)) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) MIN(1) PROMPT('Library:')
 
             PARM       KWD(ASP) TYPE(*CHAR) LEN(2) RSTD(*NO) DFT(1) +
                          RANGE(1 32) SPCVAL((*ASPDEV AD)) +
                          PMTCTL(*PMTRQS) PROMPT('ASP number')                            /*CSC043*/
             PARM       KWD(ASPDEV) TYPE(*NAME) LEN(10) DFT(*ASP) +
                          SPCVAL((*ASP) (*ASPGRPPRI) (*SYSTEM)) +
                          PMTCTL(*PMTRQS) PROMPT('ASP device')                            /*CSC043*/
 
/* If the current owner is to be revoked then a new owner must be specified. */           /*250022*/
             DEP        CTL(&CUROWNAUT *EQ '*REVOKE') PARM((&NEWOWN +
                          *NE ' ')) MSGID(PTF0009)                                        /*250022*/
/* If the *PUBLIC authority is to be *AUTL then an authorisation list must */             /*250022*/
/*  be specified.                                                          */             /*250022*/
             DEP        CTL(&PUBAUT *EQ '*AUTL') PARM((&AUTL *NE +
                          '*SAME') (&AUTL *NE '*REVOKE')) +
                          MSGID(PTF0011)                                                  /*250022*/
/* If the object is a library then CHGLIB can not be 'Y'. */                              /*250022*/
             DEP        CTL(&OBJTYPE *EQ '*LIB') PARM((&CHGLIB *NE +
                          'Y')) MSGID(PTF0012)                                            /*250022*/
