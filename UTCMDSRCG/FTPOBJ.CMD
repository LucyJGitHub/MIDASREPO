/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC000010)  VLDCKR(FTPOBJ_VC) MSGF(QCPFMSG)             */
/*EXI    HLPPNLGRP(FTPOBJ) HLPID(*CMD)                               */
/*EXI *  TEXT('Midas UT Send object(s) via FTP')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       FTPOBJ - Send objects via FTP                               */
/*                                                                   */
/*       (c) Finastra International Limited 2005                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP096 *CREATE     Date 17Mar05              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUP096 - New Utility                                        */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Send object(s) via FTP')
 
             PARM       KWD(SYSTEM) TYPE(*CHAR) LEN(15) MIN(1) +
                          PROMPT('Remote system name or address' 1)
 
             PARM       KWD(REMOTEUSER) TYPE(*NAME) LEN(10) MIN(1) +
                          PROMPT('Remote user' 2)
 
             PARM       KWD(PASSWORD) TYPE(*NAME) LEN(10) MIN(1) +
                          DSPINPUT(*NO) PROMPT('Password for remote +
                          user' 3)
 
             PARM       KWD(FROMOBJ) TYPE(*GENERIC) LEN(10) +
                          SPCVAL((*ALL)) MIN(1) MAX(100) +
                          PROMPT('Object(s) to send' 4)
 
             PARM       KWD(TOFILE) TYPE(QUAL1) MIN(1) MAX(1) +
                          PROMPT('Remote save file' 7)
 
 QUAL1:      QUAL       TYPE(*NAME) LEN(10)
             QUAL       TYPE(*CHAR) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Remote library')
 
             PARM       KWD(FROMLIB) TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('From library' 5)
 
             PARM       KWD(OBJTYPE) TYPE(*CHAR) LEN(7) RSTD(*YES) +
                          DFT(*ALL) VALUES(*ALL *ALRTBL *BNDDIR +
                          *CHTFMT *CLD *CLS *CMD *CRG *CRQD *CSI +
                          *CSPMAP *CSPTBL *DTAARA *DTAQ *EDTD +
                          *EXITRG *FCT *FILE *FNTRSC *FNTTBL +
                          *FORMDF *FTR *GSS *IGCDCT *IGCSRT *IGCTBL +
                          *IMGCLG *JOBD *JOBQ *JOBSCD *JRN *JRNRCV +
                          *LOCALE *MEDDFN *MENU *MGTCOL *MODULE +
                          *MSGF *MSGQ *NODGRP *NODL *OUTQ *OVL +
                          *PAGDFN *PAGSEG *PDFMAP *PDG *PGM *PNLGRP +
                          *PRDAVL *PRDDFN *PRDLOD *PSFCFG *QMFORM +
                          *QMQRY *QRYDFN *RCT *SBSD *SCHIDX *SPADCT +
                          *SQLPKG *SQLUDT *SRVPGM *SSND *SVRSTG +
                          *S36 *TBL *TIMZON *USRIDX *USRQ *USRSPC +
                          *VLDL *WSCST) MIN(0) MAX(25) +
                           PROMPT('Object type' 6)
 
             PARM       KWD(TGTRLS) TYPE(*CHAR) LEN(8) RSTD(*YES) +
                          DFT(*CURRENT) VALUES(*CURRENT *PRV) +
                          MIN(0) MAX(1) PROMPT('Release level on +
                          remote system' 8)
 
             PARM       KWD(RESTORE) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES) PROMPT('Restore +
                          remote object(s)?' 9)
 
             PARM       KWD(RSTLIB) TYPE(*CHAR) LEN(10) DFT(*SAVLIB) +
                          SPCVAL((*SAVLIB)) PMTCTL(PMT0) +
                          PROMPT('Restore to library' 10)
 
 PMT0:       PMTCTL     CTL(RESTORE) COND((*EQ *YES))
