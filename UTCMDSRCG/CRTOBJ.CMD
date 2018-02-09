/*********************************************************************/
/*STD    CMDBASE                                                     */
/*EXI    PGM(UTC0001) VLDCKR(UTC0002) MSGF(UTMSGF)                   */
/*EXI    HLPPNLGRP(CRTOBJ) HLPID(*CMD)                               */
/*EXI    TEXT('Midas UT Create object using CRT parameters')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       CRTOBJ - Create objects for Midas                           */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CUT008             Date 15Nov10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CPK022             Date 28Jul05              */
/*                      CPK018  *MOVED     Date 21Nov03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      187008             Date 28Nov00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      174739             Date 08Feb00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAP006             Date 07Dec98              */
/*                      CUT004             Date 28Sep98              */
/*                      123871             Date 03Oct97              */
/*                      CAA017             Date 29Jul97              */
/*                      CAA015             Date 14Jul97              */
/*                      CAA009             Date 19Aug96              */
/*                      CAAA01             Date 26Oct95              */
/*                      078080             Date 28Oct94              */
/*                      074291             Date 08Aug94              */
/*                      S01516             Date 18Jul94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CUT008 - CRTOBJ rewrite                                     */
/*                Remove keyword SUBM, add keywords DEBUG, RVKAUT.   */
/*                Object name can be entered.                        */
/*                Default value to keyword MLSYS is changed to *YES. */
/*       CPK022 - Should not use zone /COPYs.                        */
/*       CPK018 - Change MSGFLIB default to xxGTALIB.                */
/*       187008 - Set *LIBCRTAUT authority as the default value.     */
/*                - Recompiled over changed CRTOBJAUTL.              */
/*       174739 - Allow *LIBCRTAUT authority to be specified         */
/*                (Recompiled)                                       */
/*       CAP006 - APIs enhancement to use service programs.          */
/*                Opportunity taken to implement the OPTION          */
/*                keyword.  This adds the OPTION values from         */
/*                various compilers, and passes them into the        */
/*                CRTOBJ processing.  Note that not all values for   */
/*                the OPTION keyword are allowed for all compilers   */
/*                that support the keyword.  The keyword will not    */
/*                be passed into compilers that don't support it.    */
/*                As a side effect of this the NOGEN keyword is      */
/*                removed, as support for that option is provided    */
/*                here.                                              */
/*       CUT004 - Allow Core and Non-Core mode of compilation for    */
/*                Multilanguage                                      */
/*       123871 - Move the default values of OWNER and AUTL into     */
/*                core /COPYs to allow site specific defaults.       */
/*       CAA017 - Create new version of CRTOBJDM that shares the     */
/*                programs used by CRTOBJ                            */
/*       CAA015 - Introduce new parameter to allow *NOGEN creation.  */
/*       CAA009 - Introduce new parameter to prevent two level /COPY */
/*                compiles for RPG unless requested.                 */
/*              - Add dependency to stop 'Produce Expanded Listing   */
/*                Only' and 'Retain Expanded Source' being selected  */
/*                at the same time.                                  */
/*       CAAA01 - Allow expanded source to be retained for Midas GUI */
/*                Collector to run. Also, make bold printing         */
/*                optional for EXPSRC listing.                       */
/*       078080 - Add OWNER to command                               */
/*       074291 - Add AUTL to command                                */
/*       S01516 - Incorporation of enhanced CRTOBJ into core         */
/*                                                                   */
/*********************************************************************/
             CMD        PROMPT('Create objects for Midas')
 
             PARM       KWD(OBJ) TYPE(QUAL1) MIN(1) +
                          PROMPT('Object')
 QUAL1:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) MIN(1) PROMPT('Library')
 
             PARM       KWD(SRCFILE) TYPE(QUAL2) MIN(1) +
                          PROMPT('Source file')
 QUAL2:      QUAL       TYPE(*NAME) LEN(10) MIN(1)
             QUAL       TYPE(*NAME) LEN(10) DFT(*LIBL) +
                          SPCVAL((*LIBL)) PROMPT('Library')
 
             PARM       KWD(SRCMBR) TYPE(*NAME) LEN(10) DFT(*OBJ) +
                          SPCVAL((*OBJ)) MIN(0) PROMPT('Source member')
 
             PARM       KWD(OWNER) TYPE(*NAME) LEN(10) DFT(*USER) +
                        SPCVAL((*USER)) MIN(0) PROMPT('Owner')
 
             PARM       KWD(AUTL) TYPE(*NAME) LEN(10) +
                          DFT(*LIBCRTAUT) SPCVAL((*LIBCRTAUT) +
                          (*ALL) (*CHANGE) (*USE) (*EXCLUDE) +
                          (*COMPILER)) MIN(0) CHOICE(*VALUES) +
                          PROMPT('Public authority')
 
             PARM       KWD(NOCRT) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*YES *NO) MIN(0) +
                          PROMPT('Produce expanded listing only')
             PARM       KWD(KEEPSRC) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*YES *NO) MIN(0) +
                          PROMPT('Retain expanded source')
 
             PARM       KWD(MLSYS) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*YES) VALUES(*YES *NO) MIN(0) +
                          PROMPT('Multi-language system')
 
 PMT00:      PMTCTL     CTL(OWNER) COND((*NE *USER))
             PARM       KWD(RVKAUT) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*YES *NO) MIN(0) +
                          PMTCTL(PMT00) PROMPT('Revoke owner +
                          authority')
 
 PMT01:      PMTCTL     CTL(KEEPSRC) COND((*EQ *YES))
             PARM       KWD(KEEPSRCF) TYPE(QUAL2) MIN(0) +
                          PMTCTL(PMT01) PROMPT('Target file for +
                          expanded src.')
             PARM       KWD(REPLACE) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*YES) VALUES(*YES *NO) MIN(0) +
                          PMTCTL(PMT01) PROMPT('Replace member in +
                          target file')
 
 PMT02:      PMTCTL     CTL(NOCRT) COND((*EQ *YES))
             PARM       KWD(OUTPUT) TYPE(*CHAR) LEN(6) RSTD(*YES) +
                          DFT(*) VALUES(* *PRINT) PMTCTL(PMT02) +
                          PROMPT('Output for expanded listing')
             PARM       KWD(BOLD) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*YES *NO) MIN(0) +
                          PMTCTL(PMT02) PROMPT('Use bold text for +
                          expanded src')
 
 
 PMT03:      PMTCTL     CTL(MLSYS) COND((*EQ *YES))
             PARM       KWD(MSGFLIB) TYPE(*NAME) LEN(10) +
                          DFT(xxGTALIB) MIN(0) PMTCTL(PMT03) +
                          PROMPT('Multi-language files library')
             PARM       KWD(CORE) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*YES *NO) MIN(0) +
                          PMTCTL(PMT03) PROMPT('Multi-language core +
                          mode')
 
             PARM       KWD(DEBUG) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*YES *NO) MIN(0) +
                          PMTCTL(*PMTRQS) PROMPT('Allow debug')
 
             PARM       KWD(RPG2LVL) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT(*NO) VALUES(*NO *YES) PMTCTL(*PMTRQS) +
                          PROMPT('Allow two level RPG /COPY')
 
             PARM       KWD(OPTION) TYPE(*CHAR) LEN(10) RSTD(*YES) +
                          VALUES(*GEN *NOGEN *DUPPROC *NODUPPROC +
                          *DUPVAR *NODUPVAR *WARN *NOWARN *RSLVREF +
                          *UNRSLVREF *XREF *NOXREF *SECLVL +
                          *NOSECLVL *SHOWCOPY *NOSHOWCPY *EXPDDS +
                          *NOEXPDDS *EXT *NOEXT *EVENTF *NOEVENTF +
                          *SOURCE *NOSOURCE *SRC *NOSRC *DUMP +
                          *NODUMP *SRCDBG *NOSRCDBG *LSTDBG +
                          *NOLSTDBG *AGR *NOAGR *EXPMAC *NOEXPMAC +
                          *LOGMSG *NOLOGMSG *PPONLY *NOPPONLY +
                          *SHOWINC *NOSHOWINC *SHOWUSR *SHOWUSR +
                          *SHOWSYS *SHOWSKP *NOSHOWSKP) MAX(24) +
                          PMTCTL(*PMTRQS) PROMPT('Compiler +
                          options')
 
             DEP        CTL(&KEEPSRC *EQ '*YES') PARM((&NOCRT *NE +
                          '*YES')) MSGID(SYS0016)
