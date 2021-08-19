     H DEBUG DATEDIT(*YMD)
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056555
/*STD *  RPGSQLBND                                                    *                     MD056555
/*EXI *  TEXT('Midas SC Switchable features ins/del precheck')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC3010X - Precheck Switchable Features at Insert/Delete.     *
      *                                                               *
      *  Function:  This program checks that a switchable feature     *
      *             is eligible to be switched on or off. The code    *
      *             for the checks are contained in one of three      *
      *             /COPYs (Core, Regional and Customer). A return    *
      *             code is passed back to the calling program, 'Y'   *
      *             for insert/delete allowed and 'N' for not         *
      *             allowed.                                          *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056555           Date 31Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSD004             Date 31Mar99               *
      *                 CSC010             Date 12May99               *
      *                 CCB008             Date 12Oct98               *
      *                 CSC007             Date 08May98               *
      *                 CEU032             Date 18Nov98               *
      *                 CAP004             Date 01Oct98               *
      *                 CTI002             Date 23Sep98               *
      *                 CAP003             DATE 05Aug98               *
      *                 CSW014             DATE 05FEB98               *
      *                 CEU005             DATE 05FEB98               *
      *                 129765             Date 25Feb98               *
      *                 CAC003             DATE 16OCT97               *
      *                 CFF003             DATE 16OCT97               *
      *                 CAC001             DATE 16OCT97               *
      *                 CRT003             DATE 22JUL96               *
      *                 CRT002             DATE  1DEC95               *
      *                 S01408             DATE 07AUG95               *
      *                 CRT001             DATE 28FEB95               *
      *                 S01488             DATE 05AUG94               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056555 - Deliverable Data Split for SAR group              *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD004 - BTS enhancement (recompiled over changed SC3010XCOR)*
      *  CSC010 - Disable/enable switchable features processing.      *
      *  CCB008 - Synon Closedown Project (CB):                       *
      *           - File removed from CB model.                       *
      *  CEU032 - EMU SE Redenominated Security Codes Maintenance.    *
      *           (recompiled)                                        *
      *  CAP004 - Midas APIs phase 3: make CAP004 dependent on CAP002 *
      *           (recompiled over changed SC3010XCOR).
      *  CTI002 - Make installation of CTI002 dependent upon Trade    *
      *           Innovation being active.                            *
      *           (recompiled over changed SC3010XCOR).               *
      *  CSC007 - Switchable Features Enhancements phase 2.           *
      *           Amendments to Switchable Features suite of          *
      *           programs to allow switching on via passwords.       *  *
      *           New code to coincide with these amendments are      *  *
      *           under CSC005.                                       *  *
      *  CAP003 - Midas APIs phase 2: make CAP003 dependent on CAP002 *
      *           (recompiled over changed SC3010XCOR).
      *  CSW014 - Allow entry of ERI Info for non-EMU users           *
      *           Recompiled over changed /COPY                       *
      *  CEU005 - EMU SE Settlement Ccy Conversion - Recompiled       *
      *           over changed /COPY.                                 *
      *  127965 - Recompiled for changes in SC3010XCOR.               *
      *  CAC003 - PCA Development 3 - Recompiled over changed /COPY.  *
      *  CFF003 - OTC Enhancements 2 - Recompiled over changed /COPY. *
      *  CAC001 - PCA Development - Recompiled over changed /COPYs.   *
      *  CRT003 - Recompiled for changes in SC3010XCOR.               *
      *  CRT002 - Recompiled for changes in SC3010XCOR.               *
      *  S01408 - Hooks moved to WNCPYSRC from SCCPYSRC:              *
      *           - SC3010XCUS                                        *
      *           - SC3010XREG                                        *
      *  CRT001 - RTS Development - Recompiled over changed /COPYs.   *
      *  S01488 - New program created for this change.                *
      *                                                               *
      *****************************************************************
     F*SCSARXL0* IF   E           K DISK                                         CSC007     MD056555
     F*SCSARXL2* IF   E           K DISK                                         CSC007     MD056555
     FSDMMIDL1  IF   E           K DISK                                         CSC007
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D********************************************************************
     D*
     D* Description     : Copyright notice for inclusion in all programs
     D*
     D/COPY SCCPYSRC,SC3010ICOR
      /EJECT
      * Data structures:
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * Program data structure
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      7  0
     D  ##JCC                  1      1  0
     D  ##JYY                  2      3  0
     D  ##JMM                  4      5  0
     D  ##JDD                  6      7  0
     D  ##JTM                  8     13  0
     D  ##JHH                  8      9  0
     D  ##JNN                 10     11  0
     D  ##JSS                 12     13  0
     D A@CPY           DS
     D* Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              Copyright array
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      * Midas Modules file data structure
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      /EJECT
      * Parameter declarations
     D P1PARM          DS
      * I :  Action Code
     D  P1ANCD                 1      1
     D P2PARM          DS
      * I :  Switchable Feature Number
     D  P2SARN                 1      6
     D P3PARM          DS
      * O :  Allow INS/DEL of Feature
     D  P3AIDF                 1      1
     D SCSARX        E DS                  EXTNAME(SCSRXJW0)                                MD056555
     D  WALCD        E                     EXTFLD(LCD)                                      MD056555
      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C     P1ANCD        PARM                    WP0001            1            Action Code
     C     P2SARN        PARM                    WP0002            6            Switchable Feat
     C     P3AIDF        PARM      P3AIDF        WP0003            1            Allow INS/DEL o
      *****************************************************************
      * Initialize
     C                   EXSR      ZZINIT
      *
      * Switchable Feature Prechk
      * SC3010X Precompiler - Switchable Features  *
      * Copyright Statement 1994 - Standard functions  *
      * Default DSs for Prechecks - Switchable Features  *
      *
      * Switchable Features file data structure
      * 00/Copy Member SC3010XFPG - Switchable Features  *
     C/COPY WNCPYSRC,SC3010XFPG
      * 00/Copy Member SC3010XEPG - Switchable Features  *
     C/COPY WNCPYSRC,SC3010XEPG
      * 00/Copy Member SC3010XIPG - Switchable Features  *
     C/COPY WNCPYSRC,SC3010XIPG
      ****** Initialise P1AIDF Code to 'Y'.                               CSC007
     C******               MOVEL'Y'       P3AIDF           Allow INS/DEL oCSC007
      *                                                                   CSC007
      * Set up Parameter List for calling AOSARDR0                        CSC007
      *                                                                   CSC007
     C     PPARM         PLIST                                                                 CSC00
     C                   PARM      *BLANKS       @RTCD             7                           CSC00
     C                   PARM      '*VERIFY'     @OPTN             7                           CSC00
     C                   PARM                    @SARD             6                           CSC00
     C     SCSARD        PARM      SCSARD        DSFDY                                         CSC00
      *                                                                   CSC007
      * Set up Key List for accessing logical files SCSARXL0,             CSC007
      * and SCSARXL2.                                                     CSC007
      *                                                                   CSC007
     C     KPOS          KLIST                                                                 CSC00
     C                   KFLD                    ACSARN            6                           CSC00
     C                   KFLD                    ACRECI            1                           CSC00
      *                                                                   CSC007
      * Set up key for reading files (whether inserts or deletes).        CSC007
      *                                                                   CSC007
     C                   MOVEL     P2SARN        ACSARN                                        CSC00
     C                   MOVEL     'D'           ACRECI                                        CSC00
      *                                                                   CSC007
      *****************************************************************   CSC007
      * Checking dependencies for switching on a new switchable feature   CSC007
      *****************************************************************   CSC007
      *                                                                   CSC007
     C     'I'           IFEQ      P1ANCD                                                      CSC00
      * '+' means 'enable' a disabled feature                             CSC010
     C     '+'           OREQ      P1ANCD                                                      CSC01
      *                                                                   CSC007
      * Execute main dependency checking sub-routine.                     CSC007
      *                                                                   CSC007
     C                   EXSR      DEPCHK                                                      CSC00
     C                   ENDIF                                                                 CSC00
      *                                                                   CSC007
      **************************************************************      CSC007
      * Processing to check for switching off a new feature               CSC007
      **************************************************************      CSC007
      *                                                                   CSC007
     C     'D'           IFEQ      P1ANCD                                                      CSC00
      * '-' means 'disable' an active feature                             CSC010
     C     '-'           OREQ      P1ANCD                                                      CSC01
     C                   MOVE      'Y'           ALLOW                                         CSC00
     C                   MOVEL     ACSARN        XSARN             6                        MD056555
     C*****ACSARN        CHAIN     SCSARXL2                           82              CSC00 MD056555
     C/EXEC SQL                                                                             MD056555
     C+ declare ACursor insensitive scroll cursor for                                       MD056555
     C+ select * from SCSRXJW0                                                              MD056555
     C+ where DDON = :XSARN                                                                 MD056555
     C+ order by DDON, RECI, SEQ                                                            MD056555
     C/END-EXEC                                                                             MD056555
                                                                                            MD056555
     C/EXEC SQL                                                                             MD056555
     C+ open ACursor                                                                        MD056555
     C/END-EXEC                                                                             MD056555
                                                                                            MD056555
     C/EXEC SQL                                                                             MD056555
     C+ fetch next from ACursor into :SCSARD                                                MD056555
     C/END-EXEC                                                                             MD056555
                                                                                            MD056555
     C                   SETOFF                                       82                    MD056555
     C                   If        SQLCODE = 100                                            MD056555
     C                   SETON                                        82                    MD056555
     C                   Endif                                                              MD056555
      *                                                                   CSC007
      *  No dependency on dependency file                                 CSC007
      *                                                                   CSC007
     C     *IN82         IFEQ      *ON                                                         CSC00
     C                   MOVE      ACSARN        DDON                                          CSC00
     C                   ENDIF                                                                 CSC00
      *                                                                   CSC007
      *  dependency on dependency file                                    CSC007
      *                                                                   CSC007
     C     *IN82         IFEQ      *OFF                                                        CSC00
      *
      * Save pointer to this file                                         CSC007
      *                                                                   CSC007
     C                   MOVE      DDON          DDDON             6                           CSC00
     C     *IN77         DOWEQ     *OFF                                                        CSC00
      *                                                                   CSC007
      * Check whether the feature may be switched off
      *
     C     DSON          IFEQ      'NONDEL'                                                    CSC01
     C                   MOVE      'N'           ALLOW                                         CSC01
     C                   LEAVE                                                                 CSC01
     C                   ENDIF                                                                 CSC01
     C     RECI          IFEQ      'D'                                                         CSC00
     C     DOFF          ANDNE     'OFF'                                                       CSC00
     C                   MOVE      DSON          @SARD                                         CSC00
     C                   CALL      'AOSARDR0'    PPARM                                         CSC00
     C     @RTCD         IFEQ      *BLANKS                                                     CSC00
     C                   MOVE      DSON          ACSARN                                        CSC00
     C                   EXSR      DEPCHK                                                      CSC00
     C     ALLOW         IFEQ      'N'                                                         CSC00
     C                   LEAVE                                                                 CSC00
     C                   ENDIF                                                                 CSC00
     C                   ENDIF                                                                 CSC00
     C                   ENDIF                                                                 CSC00
     C*****DDDON         READE     SCSARXL2                               77          CSC00 MD056555
     C/EXEC SQL                                                                             MD056555
     C+ fetch next from ACursor into :SCSARD                                                MD056555
     C/END-EXEC                                                                             MD056555
                                                                                            MD056555
     C                   SETOFF                                       77                    MD056555
     C                   If        SQLCODE = 100                                            MD056555
     C                   SETON                                        77                    MD056555
     C                   Endif                                                              MD056555
     C                   ENDDO                                                                 CSC00
     C                   ENDIF                                                                 CSC00
     C     ALLOW         IFEQ      'Y'                                                         CSC00
     C     P1ANCD        ANDEQ     'D'                                                         CSC01
     C                   CALL      'SC3100'                                                    CSC00
     C                   PARM      *BLANKS       PASS             16                           CSC00
     C                   PARM      *BLANKS       W0RTN             7                           CSC00
     C                   PARM                    DDON                                          CSC00
     C                   PARM      'D'           MODE              1                           CSC00
     C                   PARM      *BLANKS       CORE              2                           CSC00
     C                   ENDIF                                                                 CSC00
     C                   ENDIF                                                                 CSC00
      *
      **************************************************************      CSC007
      * Set up parameters to be passed out                                CSC007
      **************************************************************      CSC007
      **Insert/Delete*allowed?********************                        CSC007
      * Insert/Delete (or Enable/Disable) allowed?                        CSC010
      * -----------------------------------------                         CSC007
      *
     C     ALLOW         IFEQ      'Y'                                                         CSC00
     C                   MOVEL     'Y'           P3AIDF                                        CSC00
     C                   ELSE                                                                  CSC00
     C                   MOVEL     'N'           P3AIDF                                        CSC00
     C                   ENDIF                                                                 CSC00
      *                                                                   CSC007
      * Core precheck /COPY.
      * Core SF Precheck /COPY - Switchable Features  *
     C/COPY SCCPYSRC,SC3010XCOR
      * Local (Regional)  precheck /COPY.
      * Regional SF Precheck - Switchable Features  *
     C/COPY WNCPYSRC,SC3010XREG
      * Customer specific precheck /COPY.
      * Customer SF Precheck - Switchable Features  *
     C/COPY WNCPYSRC,SC3010XCUS
      *================================================================
      *================================================================
      *----------------------------------------------------------------
      * Exit program
     C     AAEXIT        TAG
     C                   MOVEL     *BLANK        P0RTN
     C                   EXSR      ZYEXPG
      *================================================================
      /EJECT
      *                                                                   CSC007
      ****************************************                            CSC007
      * Dependency Checking for switching on *                            CSC007
      ****************************************                            CSC007
     C     DEPCHK        BEGSR                                                                 CSC00
      *                                                                   CSC007
      * Find the first occurrence of the switchable feature on the        CSC007
      * dependencies file.                                                CSC007
      * The file SCSARXL0 is used to find which other features or         CSC007
      * modules need to be switched on first.                             CSC007
      *                                                                   CSC007
     C*****KPOS*         CHAIN     SCSARXL0                           82              CSC00 MD056555
     C/EXEC SQL                                                                             MD056555
     C+ declare BCursor insensitive scroll cursor for                                       MD056555
     C+ select * from SCSRXJW0                                                              MD056555
     C+ where DSON = :ACSARN and RECI = :RECI                                               MD056555
     C+ order by DSON, RECI, SEQ                                                            MD056555
     C/END-EXEC                                                                             MD056555
                                                                                            MD056555
     C/EXEC SQL                                                                             MD056555
     C+ open BCursor                                                                        MD056555
     C/END-EXEC                                                                             MD056555
                                                                                            MD056555
     C/EXEC SQL                                                                             MD056555
     C+ fetch next from BCursor into :SCSARD                                                MD056555
     C/END-EXEC                                                                             MD056555
                                                                                            MD056555
     C                   SETOFF                                       82                    MD056555
     C                   If        SQLCODE = 100                                            MD056555
     C                   SETON                                        82                    MD056555
     C                   Endif                                                              MD056555
                                                                                            MD056555
     C     *IN82         IFEQ      *OFF                                                        CSC00
     C                   MOVE      *BLANKS       WSEQ              2                           CSC00
     C                   MOVE      SEQ           WSEQ                                          CSC00
     C                   ENDIF                                                                 CSC00
      *                                                                   CSC007
      * If indicator 82 is on, no record is found; i.e., this             CSC007
      * feature does not depend upon anything else being switched on.     CSC007
      *                                                                   CSC007
      *                                                                   CSC007
     C     *IN82         IFEQ      *ON                                                         CSC00
     C                   MOVE      'Y'           ALLOW                                         CSC00
     C                   ELSE                                                                  CSC00
      *                                                                   CSC007
      * The first occurence states the logical nature of the dependency   CSC007
      * with other features or modules within the sequence number.        CSC007
      * Possible values: 'A' = and, 'O' = or.                             CSC007
      *                                                                   CSC007
      * Default the 'ALLOW' flag as per the logical type 'A' or 'O'.      CSC007
      *                                                                   CSC007
     C                   EXSR      LOGDFT                                                      CSC00
      *                                                                   CSC007
      * If Logical Type = 'A', then all required features and modules     CSC007
      * must satisfy the conditions for the feature to be switched        CSC007
      * on.                                                               CSC007
      * If Logical Type = 'O', then a minimum of one condition needs      CSC007
      * to be satisfied.                                                  CSC007
      *                                                                   CSC007
     C     *IN77         DOWEQ     *OFF                                                        CSC00
     C     DTYPE         IFEQ      'S'                                                         CSC00
     C     RECI          ANDEQ     'D'                                                         CSC00
      *                                                                   CSC007
      * Call sub-routine which checks for switchable features             CSC007
      * dependencies                                                      CSC007
      *                                                                   CSC007
     C                   EXSR      SARCHK                                                      CSC00
     C                   ELSE                                                                  CSC00
     C     DTYPE         IFEQ      'M'                                                         CSC00
     C     RECI          ANDEQ     'D'                                                         CSC00
      *                                                                   CSC007
      * Call sub-routine which checks for module                          CSC007
      * dependencies                                                      CSC007
      *                                                                   CSC007
     C                   EXSR      MODCHK                                                      CSC00
     C                   ENDIF                                                                 CSC00
     C                   ENDIF                                                                 CSC00
     C*****KPOS*         READE     SCSARXL0                               77          CSC00 MD056555
     C/EXEC SQL                                                                             MD056555
     C+ fetch next from BCursor into :SCSARD                                                MD056555
     C/END-EXEC                                                                             MD056555
                                                                                            MD056555
     C                   SETOFF                                       77                    MD056555
     C                   If        SQLCODE = 100                                            MD056555
     C                   SETON                                        77                    MD056555
     C                   Endif                                                              MD056555
                                                                                            MD056555
      *                                                                   CSC007
      * Check if there are more dependencies on the file for this         CSC007
      * feature, with another sequence number                             CSC007
      *                                                                   CSC007
     C     WSEQ          IFNE      SEQ                                                         CSC00
     C     *IN77         ANDEQ     *OFF                                                        CSC00
     C     ALLOW         IFEQ      'N'                                                         CSC00
     C                   MOVE      *BLANKS       WSEQ                                          CSC00
     C                   MOVE      SEQ           WSEQ                                          CSC00
      *                                                                   CSC007
      * Reset the ALLOW flag, as the logical type might have changed      CSC007
      *                                                                   CSC007
     C                   EXSR      LOGDFT                                                      CSC00
     C                   ELSE                                                                  CSC00
     C                   MOVE      'Y'           ALLOW                                         CSC00
     C                   LEAVE                                                                 CSC00
     C                   ENDIF                                                                 CSC00
     C                   ENDIF                                                                 CSC00
     C                   ENDDO                                                                 CSC00
     C                   ENDIF                                                                 CSC00
     C                   ENDSR                                                                 CSC00
      ***************************************************************     CSC007
      *  Defaults the logical type for 'A' or 'O' processing        *     CSC007
      *  The defaults are set up like this so control can drop out  *     CSC007
      *  the main checking loop as soon as the flag is changed.     *     CSC007
      ***************************************************************     CSC007
     C     LOGDFT        BEGSR                                                                 CSC00
     C     LOGT          IFEQ      'A'                                                         CSC00
     C                   MOVE      'Y'           ALLOW             1                           CSC00
     C                   ELSE                                                                  CSC00
     C                   MOVE      'N'           ALLOW                                         CSC00
     C                   ENDIF                                                                 CSC00
     C                   ENDSR                                                                 CSC00
     C*****************************************************************   CSC007
     C*  Checks if switchable features are dependent on any other     *   CSC007
     C*  switchable features being switched on or off first, or a     *   CSC007
     C*  particular release level.                                    *   CSC007
     C*****************************************************************   CSC007
     C     SARCHK        BEGSR                                                                 CSC00
     C***********'D'       IFEQ P1ANCD                                    CSC007
     C     P1ANCD        IFEQ      'D'                                                         CSC01
     C     P1ANCD        OREQ      '-'                                                         CSC01
     C     DDON          ANDEQ     DDDON                                                       CSC00
     C                   MOVE      'IGNORE'      @RTCD                                         CSC00
     C                   EXSR      TYPCHK                                                      CSC00
     C                   ELSE                                                                  CSC00
     C                   MOVE      DDON          @SARD                                         CSC00
     C                   CALL      'AOSARDR0'    PPARM                                         CSC00
     C                   EXSR      TYPCHK                                                      CSC00
     C                   ENDIF                                                                 CSC00
     C                   ENDSR                                                                 CSC00
     C****************************************************************    CSC007
      * As soon as a a required condition is not met                 * e  CSC007
      * when the logical type is AND, drop out of processing         *    CSC007
      ****************************************************************    CSC007
     C     TYPCHK        BEGSR                                                                 CSC00
     C     LOGT          IFEQ      'A'                                                         CSC00
     C     @RTCD         IFNE      *BLANKS                                                     CSC00
     C     DOFF          ANDNE     'OFF'                                                       CSC00
      *                                                                   CSC007
      * if the feature must be off to continue processing                 CSC007
      *                                                                   CSC007
     C     @RTCD         OREQ      *BLANKS                                                     CSC00
     C     DOFF          ANDEQ     'OFF'                                                       CSC00
     C                   MOVE      'N'           ALLOW                                         CSC00
     C                   ENDIF                                                                 CSC00
     C                   ENDIF                                                                 CSC00
      *                                                                   CSC007
      * As soon as a required condition is not met when the               CSC007
      * logical type is OR, drop out of processing and allow the          CSC007
      * feature to be inserted.                                           CSC007
      *                                                                   CSC007
     C     LOGT          IFEQ      'O'                                                         CSC00
     C     @RTCD         IFEQ      *BLANKS                                                     CSC00
     C     DOFF          ANDNE     'OFF'                                                       CSC00
      *                                                                   CSC007
      * if the feature must be off to continue processing                 CSC007
      *                                                                   CSC007
     C     @RTCD         ORNE      *BLANKS                                                     CSC00
     C     DOFF          ANDEQ     'OFF'                                                       CSC00
     C                   MOVE      'Y'           ALLOW                                         CSC00
     C                   ENDIF                                                                 CSC00
     C                   ENDIF                                                                 CSC00
     C                   ENDSR                                                                 CSC00
      ********************************************************            CSC007
     C*  Checks if switchable features are dependent on any  *            CSC007
     C*  modules being switched on first                     *            CSC007
      ********************************************************            CSC007
     C     MODCHK        BEGSR                                                                 CSC00
     C     MDSN          CHAIN     SDMMIDL1                           78                       CSC00
     C     *IN78         IFEQ      *ON                                                         CSC00
     C                   MOVE      'N'           ALLOW                                         CSC00
     C                   ELSE                                                                  CSC00
     C     LOGT          IFEQ      'A'                                                         CSC00
     C     FOMMIN        IFEQ      'N'                                                         CSC00
     C     DOFF          ANDNE     'OFF'                                                       CSC00
      *                                                                   CSC007
      * if the feature must be off to continue processing                 CSC007
      *                                                                   CSC007
     C     FOMMIN        OREQ      'Y'                                                         CSC00
     C     DOFF          ANDEQ     'OFF'                                                       CSC00
     C                   MOVE      'N'           ALLOW                                         CSC00
     C                   ENDIF                                                                 CSC00
     C                   ENDIF                                                                 CSC00
     C     LOGT          IFEQ      'O'                                                         CSC00
     C     FOMMIN        IFEQ      'N'                                                         CSC00
     C     DOFF          ANDNE     'OFF'                                                       CSC00
      *                                                                   CSC007
      * if the feature must be off to continue processing                 CSC007
      *                                                                   CSC007
     C     FOMMIN        OREQ      'Y'                                                         CSC00
     C     DOFF          ANDEQ     'OFF'                                                       CSC00
     C                   MOVE      'N'           ALLOW                                         CSC00
     C                   ENDIF                                                                 CSC00
     C                   ENDIF                                                                 CSC00
     C                   ENDIF                                                                 CSC00
     C                   ENDSR                                                                 CSC00
     CSR   ZXEXPG        BEGSR
      *================================================================
      * Exit program: Normal
      *================================================================
     C                   EXSR      ZYEXPG
      *================================================================
     CSR   ZXEXIT        ENDSR
      /EJECT
     CSR   ZYEXPG        BEGSR
      *================================================================
      * Exit program: Direct
      *================================================================
     C/EXEC SQL                                                                             MD056555
     C+ close ACursor                                                                       MD056555
     C/END-EXEC                                                                             MD056555
     C/EXEC SQL                                                                             MD056555
     C+ close BCursor                                                                       MD056555
     C/END-EXEC                                                                             MD056555
      * Terminate program
     C                   SETON                                        LR
      *
      * Exit program
     C                   RETURN
      *
      *================================================================
     CSR   ZYEXIT        ENDSR
      /EJECT
     CSR   ZZINIT        BEGSR
      *================================================================
      * Initialisation
      *================================================================
     C     W0ICL         IFEQ      *BLANK
     C                   MOVEL     'Y'           W0ICL             1            *Initial call
     C                   ELSE
     C                   MOVEL     'N'           W0ICL
     C                   END
     C                   MOVE      *BLANK        P0RTN
     C                   MOVE      *BLANK        W0RTN             7
     C                   MOVEL     *BLANK        W0RSL             1
     C                   MOVEL     *BLANK        W0RSF             1
     C                   MOVEL     *ZEROS        W0RTW             9 0
     C                   MOVEL     '400'         W0ENV             3
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
      * Set century digit (If YY prior to 1940 treat as 20YY)
     C     ##JYY         IFLT      40
     C                   Z-ADD     1             ##JCC
     C                   ELSE
     C                   Z-ADD     0             ##JCC
     C                   END
     C                   TIME                    ##JTM
      * Update screen time
     C                   TIME                    ##TME             6 0
     C                   MOVEL     'N'           W0PMT             1
      *================================================================
     CSR   ZZEXIT        ENDSR
      /EJECT
     CSR   *PSSR         BEGSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
      * Core function specific processing.
      *
     C/COPY WNCPYSRC,SC3010XPSC
      *
      * Start of PSSR user point.
      *
     C/COPY WNCPYSRC,SC3010XPS1
      *
      * Standard Midas PSSR processing.
      *
     C*COPY*CBCPYSRC,CBPSSRINS                                                              MD056555
     C/COPY CBCPYSRC,CBPSSRINSL                                                             MD056555
      *
      * End of PSSR user point.
      *
     C/COPY WNCPYSRC,SC3010XPS2
      *
      *================================================================
     CSR                 ENDSR
      *================================================================
**CTDATA CPY@
(c) Finastra International Limited 2001
