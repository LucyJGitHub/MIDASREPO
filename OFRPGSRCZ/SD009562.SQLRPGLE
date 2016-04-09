     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Nostro Group Limits Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009562 - Midas OF Nostro Group Maintenance                 *
      *                                                               *
      *  Function:  This program maintains the Nostro Group           *
      *               Maintenance                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2014            *
      *                                                               *
      *  Last Amend No. MD027374           Date 05Jun14               *
      *  Prev Amend No. MD026866A          Date 22May14               *
      *                 MD026948           Date 19May14               *
      *                 MD026866           Date 14May14               *
      *                 MD026707           Date 12May14               *
      *                 MD026706           Date 06May14               *
      *                 CGL155A            Date 22Apr14               *
      *                 CGL155  *CREATE    Date 06Mar14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD027374 - Amendment and deletion allowed even if the user   *
      *             is not authorised.                                *
      *  MD026866A - Issue COMMIT on update of database instead of    *
      *              at program exit.                                 *
      *  MD026948 - F12 is not available                              *
      *  MD026866 - Issues with replication                           *
      *  MD026707 - Nostro fields not highlighted if not inputted.    *
      *  MD026706 - Incorrect error message when amount is blank      *
      *  CGL155A - Forecast Group Limit                               *
      *  CGL155 - Forecast Group Limits                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Forecast Static Data Display File
     FSD009562DFCF   E             WORKSTN USROPN
     F                                     SFILE(SD009562S1:SRLRN)
     F                                     SFILE(SD009562S2:SRLRN2)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **----------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Review from fields
     D                 DS
     D  SPOSN                  1      5
 
      ** Display file information data structure
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
 
      ** Rundate data area
     D RUNDAT          DS
     D  WSUC                  11     11
     D  WMBIN                 13     13
 
      ** ZMUSER data area
     D ZMUSER          DS
     D  DBRN                  11     13
     D  BANK                  17     17
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      **  External DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External DS for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
 
      ** External DS for Account Details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(A_)
 
      ** Externally described DS for Retail ICD details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACCDX      E                     EXTFLD(QQACCD)
 
     D NostroGHDS    E DS                  EXTNAME(SDNGLHTD)
     D                                     PREFIX(A_)
 
     D NostroGDDS    E DS                  EXTNAME(SDNGLDTD)
     D                                     PREFIX(B_)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)                                    CGL155A
 
     D S2NOST          DS
     D  DSNCCY                 1      3
     D  DSNOSC                 4      5
     D S2NOSTH         DS
     D  DSNCCYH                1      3
     D  DSNOSCH                4      5
 
     D WANOST          S              5A   DIM(1000)
     D WASNOST         S              5A   DIM(1000)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
     D CAIN89          S              1
 
      ** Database error workfields
     D PRTCD           S              7
     D POPTN           S              7
     D PCNCD           S              2
     D PACOD           S             10
     D PCUST           S              6                                                      CGL155A
     D PACCN           S             10                                                      CGL155A
     D PACSN           S              2                                                      CGL155A
     D PBRCD           S              3                                                      CGL155A
     D PCSSN           S             10                                                      CGL155A
     D PPNOI           S              1                                                      CGL155A
 
      ** Message file workfields - Parameters list for ZA0340 / ZA0350
     D PZMsgFile       S             10A   INZ('GBSDUSRMSG')
     D PZMsgID         S             10
     D PZMsgDta        S             45A
 
      ** General workfields
     D CAIN81          S              1
     D PMODE           S              1
     D W#ACT           S              1
     D WKIPIN          S              1
     D WFNAM           S             10
     D WCUST           S              1
     D WLRCD           S              4  0
     D WPOSN           S              5
     D WRCTR           S              5  0
     D WRCTR2          S              5  0
     D WSFPG           S              3  0
     D WSFPG2          S              3  0
     D W1PMD           S              3
     D W1RSF           S              1
     D W2RSF           S              1
     D W#EROR          S              1
     D W#EROR2         S              1
     D WTIME           S               Z
     D WCDPL           S              1S 0
     D WCTR            S              5S 0
     D WCTR1           S              5S 0
     D WCTR2           S              5S 0
     D WCTR3           S              5S 0
     D WCTR4           S              5S 0
     D WCNT            S              5S 0
     D wSRLRN          S              4S 0
     D wSRLRNpc        S              4S 0
     D wSRLRN2         S              4S 0
     D wSRLRN2pc       S              4S 0
     D WNoDetail       S              1A
     D WSKIP           S              1A
     D WSVAM           S             15  0
     D WSVNODES        S             20A
     D WSVDLMT         S             16A
     D WSVCURR         S              3A
     D WUPDFLG         S              1A
     D WZONE           S             10A
     D PSCRF           S             16A
     D PNDEC           S              1  0
     D PNDIG           S              2  0
     D PRVAL           S             16A
     D PZRTCD          S              7A
     D PZERMS          S             50A
     D PZFCHK          S              1A
     D PZZONE          S             10
     D PZSHTC          S              4
     D PZRDNB          S              5S 0
     D PZDNWD          S              5S 0
     D PZBCCY          S              3
     D PZNJOB          S              1S 0
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1A
     D ZOUT21          S             21A
     D PActn           S              1A
     D PBrc            S              3A
     D PError          S              1  0
     D NCUST           S              6A
     D NACOD           S             10A
     D NACSQ           S              2A
     D NBRCA           S              3A
     D*WSkipRec*       S              1                                                      CGL155A
 
      ** Parameters for ZALIGN/ZEDIT
     D ZALIGNOK        S              1
     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ZADIG           S              2  0
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
     C/exec SQL                                                                             MD026866
     C+ set option COMMIT = *CHG                                                            MD026866
     C/end-exec                                                                             MD026866
 
      ** Main Program
 
     C                   DO        *HIVAL
 
      ** Initialise and load subfile page
 
     C                   IF        *IN32 = *OFF                                              CGL155A
     C                   EXSR      SRBldSfl1
     C                   ENDIF                                                               CGL155A
 
     C                   EVAL      W1RSF = 'N'
 
      ** Display screen until reload requested
 
     C                   DOW       W1RSF = 'N'
 
      ** Display screen
 
     C                   EXSR      SRDspSfl1
 
      ** Process response
 
     C     *IN03         CASEQ     *ON           SREnd
 
     C     *IN27         CASEQ     *ON           SRLoadSfl1
 
     C                   CAS                     SRProcess
     C                   ENDCS
 
     C                   IF        *IN03 = *ON
     C                   EXSR      SREnd
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDDO
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl1 - Initialise and Load Subfile Page                  *
      *                                                               *
      *****************************************************************
 
     C     SRBldSfl1     BEGSR
 
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD009562C1
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN79 = *OFF
 
      ** Reset Number of Records in Subfile
 
     C                   EVAL      WLRCD = 0
 
      ** If CHANGE mode, then position file
 
     C                   EVAL      *IN82 = *OFF
 
     C                   IF        W1PMD <> 'ADD'
     C                   EVAL      WPOSN = SPOSN
 
      ** Setup key
 
     C/exec SQL
     C+ close NostroGH
     C/end-exec
 
     C/exec sql
     C+ open NostroGH
     C/end-exec
 
     C/exec SQL
     C+ fetch next
     C+ from NostroGH
     C+ into :NostroGHDS
     C/end-exec
 
     C                   ELSE
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF
 
     C                   If        %Subst(SQLState:1:2) = '02'
     C                   EVAL      *IN82 = *ON
     C                   ENDIF
 
      ** Save previous selector values
 
     C     *LIKE         DEFINE    S1POS1        WZNOSG
     C                   EVAL      WZNOSG = S1POS1
 
      ** Load subfile page
 
     C                   EXSR      SRLoadSfl1
 
      ** If no records found, display error message
 
     C                   IF        %Subst(SQLState:1:2) = '02' AND SRLRN = 0
     C                   EVAL      PZMsgID = 'USR7590'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl2 - Initialise and Load Subfile Page for Screen 2     *
      *                                                               *
      *****************************************************************
 
     C     SRBldSfl2     BEGSR
 
     C/exec sql
     C+ declare NostroGD Scroll Cursor
     C+  for select *
     C+  from SDNGLDTD
     C+ where NCGRPC = :S1NOGRP and NCRECI = 'D'
     C/end-exec
 
     C/exec sql
     C+ open NostroGD
     C/end-exec
 
      ** If CHANGE mode, then position file
 
     C                   EVAL      *IN92 = *OFF
 
     C                   IF        W1PMD <> 'ADD'
     C                   EVAL      WPOSN = SPOSN
 
      ** Setup key
 
     C/exec SQL
     C+ close NostroGD
     C/end-exec
 
     C/exec sql
     C+ open NostroGD
     C/end-exec
 
     C/exec SQL
     C+ fetch next
     C+ from NostroGD
     C+ into :NostroGDDS
     C/end-exec
 
     C                   ELSE
     C                   EVAL      *IN92 = *OFF
     C                   ENDIF
 
     C                   If        %Subst(SQLState:1:2) = '02'
     C                   EVAL      *IN92 = *ON
     C                   ENDIF
 
      ** Load subfile page
 
     C                   EXSR      SRLoadSfl2
 
      ** If no records found, display error message
 
     C                   IF        %Subst(SQLState:1:2) = '02' AND SRLRN = 0
     C                   EVAL      PZMsgID = 'USR7590'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoadSfl1 - Load Subfile Page for Screen 1                   *
      *                                                               *
      *****************************************************************
 
     C     SRLoadSfl1    BEGSR
 
      ** Load subfile page but write empty page if add mode
 
     C                   EVAL      *IN84 = *OFF
 
      ** Re-establish fields in read-ahead record
 
     C                   IF        W1PMD <> 'ADD' and *IN27 = *ON
 
     C/exec SQL
     C+ fetch prior
     C+ from NostroGH
     C+ into :NostroGHDS
     C/end-exec
 
     C/exec SQL
     C+ fetch next
     C+ from NostroGH
     C+ into :NostroGHDS
     C/end-exec
 
     C                   ENDIF
 
      ** Start at previous highest record in SFL
 
     C                   EVAL      SRLRN = WLRCD
     C                   EVAL      WRCTR = 1
 
      ** Load next subfile page
 
     C                   DOW       %Subst(SQLState:1:2) <> '02'
     C                             and WRCTR <= WSFPG
 
     C**********         EVAL      WSkipRec = 'N'                                            CGL155A
     C                   ADD       1             SRLRN
     C                   EVAL      *IN32 = *OFF
 
      ***Protect*fields*during*Enquiry*Mode**                                                CGL155A
 
     C**********         IF        (W1PMD <> 'ADD')                                          CGL155A
     C**********         SELECT                                                              CGL155A
 
     C**********         WHEN      S1POS1 <> *BLANK  AND  A_NGGRPC <> S1POS1                 CGL155A
     C**********         EVAL      WSkipRec = 'Y'                                            CGL155A
 
     C**********         ENDSL                                                               CGL155A
     C**********         ENDIF                                                               CGL155A
 
     C**********         IF        WSkipRec = 'N'                                            CGL155A
 
      ** Clear subfile fields
 
     C                   EXSR      SRClrScrn
 
      ** If CHANGE mode, load subfile fields
 
     C                   IF        W1PMD <> 'ADD'
     C                   EXSR      SRMoveSfl1
 
     C                   ENDIF
 
      ** Output to subfile
 
     C                   ADD       1             WRCTR                81
     C                   EVAL      *IN81 = *ON
 
      ** If SFLRCD invalid, note that errors present
 
     C                   IF        *IN83 = *ON and *IN40 = '0'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   WRITE     SD009562S1
 
     C**********         ELSE                                                                CGL155A
     C**********         SUB       1             SRLRN                                       CGL155A
     C**********         ENDIF                                                               CGL155A
 
      ** End of File
 
     C                   IF        W1PMD <> 'ADD'
 
     C/exec SQL
     C+ fetch next
     C+ from NostroGH
     C+ into :NostroGHDS
     C/end-exec
 
     C                   IF        %Subst(SQLState:1:2) = '02'
     C                   EVAL      *IN82 = *ON
     C                   ELSE
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      WLRCD = SRLRN
     C                   EVAL      wSRLRN = SRLRN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoadSfl2 - Load Subfile Page for Screen 2                   *
      *                                                               *
      *****************************************************************
 
     C     SRLoadSfl2    BEGSR
 
      ** Load subfile page but write empty page if add mode
 
     C                   EVAL      *IN84 = *OFF
 
      ** Re-establish fields in read-ahead record
 
     C                   IF        W1PMD <> 'ADD' and *IN27 = *ON
 
     C/exec SQL
     C+ fetch prior
     C+ from NostroGD
     C+ into :NostroGDDS
     C/end-exec
 
     C/exec SQL
     C+ fetch next
     C+ from NostroGD
     C+ into :NostroGDDS
     C/end-exec
 
     C                   ENDIF
 
      ** Start at previous highest record in SFL
 
     C                   EVAL      WRCTR2 = 1
 
      ** Load next subfile page
 
     C                   DOW       %Subst(SQLState:1:2) <> '02'
     C                             and WRCTR2 <= WSFPG2
 
     C                   ADD       1             SRLRN2
     C                   EVAL      *IN32 = *OFF
 
      ** Clear subfile fields
 
     C                   EXSR      SRClrSfl2
 
      ** If CHANGE mode, load subfile fields
 
     C                   IF        W1PMD <> 'ADD'
 
     C                   EVAL      S2NOST = B_NCNCCY + B_NCNOSC
     C                   EXSR      SRMoveSfl2
 
      ** Output to subfile
 
     C                   ADD       1             WRCTR2               81
     C                   EVAL      *IN91 = *ON
 
      ** If SFLRCD invalid, note that errors present
 
     C                   IF        *IN83 = *ON and *IN40 = '0'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   WRITE     SD009562S2
 
     C                   ELSE
     C                   SUB       1             SRLRN2
     C                   ENDIF
 
      ** End of File
 
     C                   IF        W1PMD <> 'ADD'
 
     C/exec SQL
     C+ fetch next
     C+ from NostroGD
     C+ into :NostroGDDS
     C/end-exec
 
     C                   IF        %Subst(SQLState:1:2) = '02'
     C                   EVAL      *IN92 = *ON
     C                   ELSE
     C                   EVAL      *IN92 = *OFF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      wSRLRN2 = SRLRN2
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspSfl1 - Display Subfile for 1st screen                   *
      *                                                               *
      *****************************************************************
 
     C     SRDspSfl1     BEGSR
 
      ** Set screen conditioning indicators
 
     C                   IF        W1PMD = 'CHG'
     C                   EVAL      *IN89 = *OFF
     C                   ELSE
     C                   EVAL      *IN89 = *ON
     C                   ENDIF
     C                   EVAL      *IN88 = *OFF                                             MD026948
 
      ** PUTOVR unless conditioned fields change
 
     C                   IF        *IN89 <> CAIN89 OR *IN81 <> CAIN81
     C                   EVAL      *IN86 = *OFF
     C                   ENDIF
 
     C                   EVAL      CAIN89 = *IN89
     C                   EVAL      CAIN81 = *IN81
 
      ** Display appropriate Header depending upon Mode whether it is
      ** Enquiry or Maintenance
 
     C                   TIME                    S1TIME
     C                   WRITE     SD009562C3
     C                   WRITE     SD009562F1
     C                   EXFMT     SD009562C1
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
     C                   IF        @#SFRC <> 0
     C                   EVAL      wSRLRNpc = @#SFRC
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspSfl2 - Display Subfile for 2nd Screen                   *
      *                                                               *
      *****************************************************************
 
     C     SRDspSfl2     BEGSR
 
     C                   EVAL      *IN88 = *ON                                              MD026948
     C                   EVAL      *IN89 = *ON
 
      ** PUTOVR unless conditioned fields change
 
     C                   IF        *IN89 <> CAIN89 OR *IN81 <> CAIN81
     C                   EVAL      *IN86 = *OFF
     C                   ENDIF
 
     C                   EVAL      CAIN89 = *IN89
     C                   EVAL      CAIN81 = *IN81
 
     C                   EVAL      S2RUNA = BJMRDT
     C                   EVAL      S2WSID = PSUser
 
     C                   DOW       *IN03 = *OFF
     C                             and W1RSF = 'N'
 
     C                   TIME                    S2TIME
     C                   WRITE     SD009562C3
     C                   WRITE     SD009562F1
     C                   EXFMT     SD009562C2
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
     C                   EVAL      W#EROR = *BLANKS
     C                   EVAL      W#EROR2 = *BLANKS
     C                   MOVEA     '00000'       *IN(40)
 
     C                   IF        @#SFRC <> 0
     C                   EVAL      wSRLRN2pc = @#SFRC
     C                   ENDIF
 
     C                   IF        *IN03 = *ON
     C                   LEAVE
     C                   ENDIF
 
     C                   IF        *IN12 = *ON                                              MD026948
     C                   LEAVE                                                              MD026948
     C                   ENDIF                                                              MD026948
                                                                                            MD026948
     C                   IF        *IN27 = *ON
 
     C                   IF        S1ACTN = 'I' OR
     C                             S1ACTN = 'A'
     C                   EXSR      SRLoadInpScr
     C                   ELSE
     C                   EXSR      SRLoadSfl2
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        *IN38 <> *ON AND
     C                             *IN39 <> *ON
 
     C                   EXSR      SRValInpScr
 
     C                   IF        *IN40 = *OFF
     C                   EXSR      SRValSfl2
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      W1RSF = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVAL      *IN37 = *OFF
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
     C                   IF        *IN03 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      W1PMD = 'ADD'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess - Process Screen Input                              *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
      ** Change of position specified
 
     C                   IF        W1PMD <> 'ADD' and WPOSN <> SPOSN
     C                             OR WZNOSG <> S1POS1
     C
     C                   EXSR      SRReload
     C                   ENDIF
 
      ** Quit if reload requested
 
     C                   IF        W1RSF <> 'Y'
 
     C                   IF        *IN81 = *ON
     C                   EVAL      WKIPIN = 'N'
     C                   ENDIF
 
      ** Process subfile records
 
     C                   EXSR      SRProcRec
 
 
      ** Switch between *CHANGE modes is allowed when no errors
      ** exists during update
 
     C                   IF        *IN09 = *ON AND *IN40 = *OFF
     C                   EXSR      SRMode
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInsert - Update Records from Subfile                        *
      *                                                               *
      *****************************************************************
 
     C     SRInsert      BEGSR
 
      ** Initialise subfile reload flag
 
     C                   IF        W1PMD = 'ADD'
     C                   EVAL      W1RSF = 'Y'
     C                   ELSE
     C                   EVAL      W1RSF = 'N'
     C                   ENDIF
 
     C                   EVAL      WTIME = %TIMESTAMP
     C**********         EXSR      SRInsSDNGLDTD                                             CGL155A
     C                   EXSR      SRInsSDNGLHTD
     C                   IF        SQLCOD = 0                                                CGL155A
     C                   EXSR      SRInsSDNGLDTD                                             CGL155A
     C                   ENDIF                                                               CGL155A
 
      ** Cancel reload if errors occur
 
     C                   IF        *IN40 = *ON
     C                   EVAL      W1RSF = 'N'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - Update Records from Subfile                        *
      *                                                               *
      *****************************************************************
 
     C     SRUpdate      BEGSR
 
     C                   EVAL      WTIME = %TIMESTAMP
     C                   EXSR      SRUpdSDNGLDTD
     C                   EXSR      SRUpdSDNGLHTD
 
      ** Cancel reload if errors occur
 
     C                   IF        *IN40 = *ON
     C                   EVAL      W1RSF = 'N'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcRec - Process Request                                   *
      *                                                               *
      *****************************************************************
 
     C     SRProcRec     BEGSR
 
      ** Create Nostro Group Details
 
     C                   EVAL      *IN71 = *OFF
     C                   EVAL      *IN73 = *OFF
     C                   EVAL      *IN70 = *ON
     C                   EVAL      *IN89 = *ON
     C                   EVAL      W#ACT = *BLANKS
 
      ** Process Amend/Delete Request
 
     C                   IF        W1PMD = 'CHG' and *IN09 <> *ON
 
     C                   DOW       *IN03 = *OFF and
     C                             W1RSF = 'N' and WLRCD <> *ZEROS
 
     C                   EVAL      WCTR  = 1
     C                   DOW       WCTR <= wSRLRN
 
     C                   EVAL      *IN32 = *OFF
     C     WCTR          CHAIN     SD009562S1
 
     C                   IF        %FOUND
 
     C                   IF        S1ACTN <> ' '
 
      ** Invalid Action Code
 
     C                   IF        (S1ACTN <> 'E' and S1ACTN <> 'D' and
     C                             S1ACTN <> 'A')
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      PZMsgID = 'XXX9031'
     C                   EXSR      SRZasnms
     C     WCTR          CHAIN     SD009562S1
     C                   IF        %FOUND
     C                   EVAL      *IN32 = *ON
     C                   UPDATE    SD009562S1
     C                   ENDIF
     C                   LEAVE
     C                   ELSE
     C                   EVAL      W#ACT = S1ACTN
     C                   IF        S1ACTN = 'E'
     C                   EXSR      SREnqReq
     C                   ENDIF
 
      ** Check if Delete
     C                   IF        S1ACTN = 'D' and PMODE = 'M'
                                                                                            MD027374
     C                   EXSR      ACTCHECK                                                 MD027374
                                                                                            MD027374
     C                   IF        *IN40 = *OFF                                             MD027374
     C                   EXSR      SRDelReq
     C                   COMMIT                                                            MD026866A
                                                                                            MD027374
     C                   ENDIF                                                              MD027374
                                                                                            MD027374
     C                   ENDIF
 
      ** Check if Amend
     C                   IF        S1ACTN = 'A' and PMODE = 'M'
                                                                                            MD027374
     C                   EXSR      ACTCHECK                                                 MD027374
                                                                                            MD027374
     C                   IF        *IN40 = *OFF                                             MD027374
                                                                                            MD027374
      ** Save current position of subfile
     C                   EXSR      SRAmdReq
     C                   COMMIT                                                            MD026866A
                                                                                            MD027374
     C                   ENDIF                                                              MD027374
                                                                                            MD027374
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        *IN03 = *ON
     C                   LEAVE
     C                   ENDIF
 
     C     WCTR          CHAIN     SD009562S1
     C                   IF        %FOUND
     C                   EVAL      S1ACTN = *BLANKS                                          CGL155A
     C                   EVAL      SRLRN = wSRLRNpc
     C                   UPDATE    SD009562S1
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
 
     C                   EVAL      WCTR  += 1
     C                   ENDDO
     C                   EVAL      W1RSF = 'Y'
 
     C                   ENDDO
 
      ** If subfile is empty, resend message
 
     C                   IF        WLRCD = *ZEROS
     C                   EVAL      PZMsgID = 'USR7590'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        *IN09 = *ON and PMODE = 'M'
 
     C                   EVAL      S1ACTN = 'I'
 
      ** If not multi-branching, check authority to only action code.
 
     C                   IF        BJSBRC <> *BLANK
 
     C                   CALL      'ZVACTU'
     C                   PARM      S1ACTN        PActn
     C                   PARM                    PError
 
     C                   IF        PError <> *ZERO
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      PZMsgID = 'XXX9032'
     C                   EXSR      SRZasnms
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   ELSE
 
      ** If multi-branching, check authority to user's default branch.
 
     C                   CALL      'ZVACTBU'
     C                   PARM      S1ACTN        PActn
     C                   PARM      DBRN          PBrc
     C                   PARM                    PError
 
     C                   IF        PError = 1
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      PZMsgID = 'XXX9032'
     C                   EXSR      SRZasnms
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   IF        PError = 2
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      PZMsgID = 'XXX9032'
     C                   EXSR      SRZasnms
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
      ** Process Add Request
 
     C                   IF        *IN40 = *OFF
     C                   EVAL      W#ACT = 'I'
     C                   EXSR      SRAddReq
 
      ** Update Database
 
     C                   IF        (W#EROR =*BLANKS) AND (WKIPIN = 'Y')
     C                             and *IN03 = *OFF
     C                   EXSR      SRInsert
     C                   COMMIT                                                            MD026866A
     C                   ENDIF
 
     C                   IF        W#EROR = *BLANKS
     C                             and *IN03 = *OFF
     C                   EVAL      W1PMD = 'ADD'
     C                   EXSR      SRReload
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN43 = *OFF
     C                   EVAL      *IN44 = *OFF
     C                   EVAL      *IN84 = *OFF
     C                   EVAL      *IN89 = *OFF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnqReq - Process Enquire Request                            *
      *                                                               *
      *****************************************************************
 
     C     SREnqReq      BEGSR
 
     C/EXEC SQL
     C+    SELECT *
     C+ into :NostroGDDS
     C+ from SDNGLDTD
     C+ where NCGRPC = :S1NOGRP and NCRECI = 'D'
     C/END-EXEC
 
     C                   If        %Subst(SQLState:1:2) = '02'
 
      ** Error message if record is missing
 
     C                   EVAL      *IN40 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7517'
     C                   EXSR      SRZasnms
     C                   ELSE
 
     C                   EXSR      SRInitHdr2
 
     C                   EXSR      SRInitSfl2
 
     C                   EVAL      S2MODE = 'ENQUIRY'
     C                   EVAL      S2NOGRP = S1NOGRP
     C                   EVAL      S2NODES = S1NODES
     C                   EVAL      S2DLMT = S1DLMT
     C                   EVAL      S2CURR = S1CURR
 
      ** Initialise & load blank subfile page
 
 
      ** Reset field error indicators.
 
     C                   EVAL      *IN36 = *OFF
     C                   EVAL      *IN37 = *OFF
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN39 = *OFF
 
     C                   EXSR      SRBldSfl2
 
     C                   DOW       *IN03 = *OFF and
     C                             *IN12 = *OFF and                                         MD026948
     C                             W1RSF = 'N'
 
      ** Display Screen 2
 
     C                   EXSR      SRDspSfl2
 
     C                   IF        *IN03 = *OFF
     C                   EVAL      W1RSF = 'Y'
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
     C                   EVAL      W1RSF = 'N'
     C                   IF        W#ACT = 'E'
     C                   EVAL      *IN38 = *OFF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInitHdr2 - Initialize header field and indcators in 2nd scrn*
      *                                                               *
      *****************************************************************
 
     C     SRInitHdr2    BEGSR
 
     C                   EVAL      *IN41   = *OFF
     C                   EVAL      *IN42   = *OFF
     C                   EVAL      *IN43   = *OFF
     C                   EVAL      *IN44   = *OFF
     C                   EVAL      S2NOGRP = *BLANKS
     C                   EVAL      S2NODES = *BLANKS
     C                   EVAL      S2DLMT = *BLANKS
     C                   EVAL      S2CURR = *BLANKS
     C                   EVAL      S2NOGRP = *BLANKS
     C                   EVAL      WSVNODES = *BLANKS
     C                   EVAL      WSVDLMT = *BLANKS
     C                   EVAL      WSVCURR = *BLANKS
     C                   EVAL      WUPDFLG = 'N'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInitSfl2 - Initialize subfile 2                             *
      *                                                               *
      *****************************************************************
 
     C     SRInitSfl2    BEGSR
 
     C                   EVAL      *IN90 = *ON
     C                   WRITE     SD009562C2
     C                   EVAL      *IN90 = *OFF
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      SRLRN2  = 0
     C                   EVAL      wSRLRN2  = 0
     C                   EVAL      W#EROR = *BLANKS
     C                   EVAL      W1RSF = 'N'
     C                   EVAL      WCTR3 = 0
     C                   EVAL      WANOST = *BLANKS
     C                   EVAL      WASNOST = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoadInpScr  - Load Input Subfile screen                     *
      *                                                               *
      *****************************************************************
 
     C     SRLoadInpScr  BEGSR
 
     C                   EVAL      SRLRN2 = wSRLRN2
     C                   EVAL      WCTR4  = 1
     C                   DOW       WCTR4 <= 10
 
     C                   EVAL      S2NOST = *BLANKS
     C                   EVAL      S2NOSTH = *BLANKS
     C                   EVAL      S2ACNM = *BLANKS
     C                   EVAL      S2RPTN = *BLANKS
     C                   EVAL      S2RPTT = *BLANKS
     C                   EVAL      WCTR4  += 1
     C                   EVAL      SRLRN2 += 1
 
     C                   WRITE     SD009562S2
     C                   ENDDO
     C                   EVAL      wSRLRN2 = SRLRN2
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValInpScr   - Validate Input screen                         *
      *                                                               *
      *****************************************************************
 
     C     SRValInpScr   BEGSR
 
      ** Nostro Group Validation
      ** -----------------------
 
     C                   IF        S2NOGRP = *Blanks
 
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      W#EROR = 'Y'
     C**********         EVAL      PZMsgID = 'XXX9032'                                       CGL155A
     C                   EVAL      PZMsgID = 'XXX9052'                                       CGL155A
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
     C                   EVAL      WCNT = 0
 
     C                   EXSR      SRChkSDNGLHTD
 
     C                   IF        WCNT <> 0
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'XXX9033'
     C                   EXSR      SRZasnms
     C                   ELSE
 
 
     C                   IF        S2CURR =  *BLANKS
 
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN44 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0233'
     C                   EXSR      SRZasnms
 
     C                   ELSE
      ** Must be a valid currency
 
     C/exec sql
     C+ select * into :SDCURR from SDCURRPD
     C+ where A6CYCD = :S2CURR
     C/end-exec
 
      ** Invalid currency
 
     C                   IF        SQLCOD <> 0
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN44 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'XXX9034'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ** Keep decimal places
 
     C                   EVAL      WCDPL = A6NBDP
     C                   ENDIF
      ** Validate Daily Limit
      ** ---------------------------
 
     C                   EVAL      WSVAM = 0
 
     C                   IF        S2DLMT <> *BLANKS
 
     C                   EVAL      PSCRF = *BLANKS
 
     C                   MOVE      S2DLMT        PSCRF
     C                   MOVE      WCDPL         PNDEC
     C     15            SUB       WCDPL         PNDIG
 
     C                   CALL      'ZALIGN'      PPAR1
 
     C                   IF        PRTCD <> *BLANKS
 
      ** Nostro Daily limit not valid
 
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN43 = *ON
     C                   EVAL      W#EROR  = 'Y'
     C                   EVAL      PZMsgID = 'XXX9036'
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
      ** Keep Amount in a numeric field
 
     C                   MOVE      PRVAL         WSVAM
 
     C                   IF        WSVAM <= 0
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN43 = *ON
     C                   EVAL      W#EROR  = 'Y'
     C                   EVAL      PZMsgID = 'XXX9035'
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
      ** Edit the amount
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WSVAM         ZFLD15
     C                   EVAL      ZDECS = WCDPL
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      *BLANKS       ZECODE
     C                   PARM                    ZOUT21
 
     C                   EVAL      S2DLMT = %SUBST(ZOUT21:5:16)
     C                   ENDIF
 
     C                   ENDIF
      ** Daily limit equal to zero
     C                   ELSE
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN43 = *ON
     C                   EVAL      W#EROR  = 'Y'
     C********           EVAL      PZMsgID = 'XXX9035'                                     MD026706
     C                   EVAL      PZMsgID = 'XXX9036'                                     MD026706
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValInpSfl   - Validate Input Subfile screen                 *
      *                                                               *
      *****************************************************************
 
     C     SRValInpSfl   BEGSR
 
     C                   EVAL      WNoDetail = 'Y'
     C                   EVAL      WCTR1  = 1
     C                   EVAL      WCTR2 += 0
     C                   EVAL      WANOST = *BLANKS
     C                   DOW       WCTR1 <= wSRLRN2
 
     C     WCTR1         CHAIN     SD009562S2
 
     C                   EVAL      *IN51 = *OFF
     C                   IF        %FOUND
 
     C                   IF        S2NOST <> *BLANKS
     C                   EVAL      WNoDetail = 'N'
 
     C                   EXSR      SRChkNOSTRO
 
     C                   EXSR      SRChkSDNGLDTD
 
     C                   IF        WCNT <> 0
 
     C                   EVAL      *IN51  = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'XXX9039'
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
     C                   EXSR      SRChkSDFCSDTD
 
     C                   IF        WCNT <> 0
 
     C                   EVAL      *IN51  = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'XXX9041'
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
     C                   IF        %LOOKUP(S2NOST:WANOST) > 0
     C                   EVAL      *IN51  = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C**********         EVAL      PZMsgID = 'XXX9039'                                       CGL155A
     C                   EVAL      PZMsgID = 'XXX9038'                                       CGL155A
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      WCTR2 += 1
     C                   EVAL      WANOST(WCTR2) = S2NOST
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   UPDATE    SD009562S2
 
     C                   ELSE
 
     C                   IF        S2ACNM <> *BLANKS OR
     C                             S2RPTN <> *BLANKS OR
     C                             S2RPTT <> *BLANKS
     C                   EVAL      S2ACNM = *BLANKS
     C                   EVAL      S2RPTN = *BLANKS
     C                   EVAL      S2RPTT = *BLANKS
     C                   UPDATE    SD009562S2
     C                   ENDIF
 
     C                   EVAL      SRLRN2 = wSRLRN2pc
     C                   UPDATE    SD009562S2
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WCTR1  += 1
 
     C                   ENDDO
 
     C                   IF        WNoDetail = 'Y'
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'XXX9040'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        W#EROR = *BLANKS and
     C                             W#EROR2 = *BLANKS and
     C                             *IN03 = *OFF
 
     C                   EVAL      W1PMD  = 'CHG'
 
     C                   IF        W#ACT = 'D' AND *IN10 = *OFF
     C                   EVAL      W1RSF = 'N'
     C                   ELSE
     C                   EVAL      W1RSF = 'Y'
     C                   ENDIF
     C                   EVAL      WKIPIN = 'Y'
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValSfl2     - Validate subfile second screen                *
      *                                                               *
      *****************************************************************
 
     C     SRValSfl2     BEGSR
 
     C                   EVAL      WNoDetail = 'Y'
     C                   EVAL      WCTR1  = 1
     C                   EVAL      WCTR2  = 0
     C                   EVAL      WANOST = *BLANKS
     C                   DOW       WCTR1 <= wSRLRN2
 
     C     WCTR1         CHAIN     SD009562S2
 
     C                   EVAL      *IN51 = *OFF
     C                   IF        %FOUND
 
     C                   IF        S2NOST <> *BLANKS
     C                   EVAL      WNoDetail = 'N'
     C                   ENDIF
 
     C                   IF        S2NOST <> *BLANKS
 
     C                   IF        S2NOST <> S2NOSTH
 
     C                   EXSR      SrChkNOSTRO
 
     C                   EXSR      SRChkSDNGLDTD
 
     C                   IF        WCNT <> 0
 
     C                   EVAL      *IN51  = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'XXX9039'
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
     C**********         EXSR      SRChkSDFCSDTD                                             CGL155A
 
     C**********         IF        WCNT <> 0                                                 CGL155A
 
     C**********         EVAL      *IN51  = *ON                                              CGL155A
     C**********         EVAL      W#EROR2 = 'Y'                                             CGL155A
     C**********         EVAL      PZMsgID = 'XXX9041'                                       CGL155A
     C**********         EXSR      SRZasnms                                                  CGL155A
 
     C**********         ELSE                                                                CGL155A
 
     C                   IF        %LOOKUP(S2NOST:WANOST) > 0
     C                   EVAL      *IN51  = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C**********         EVAL      PZMsgID = 'XXX9039'                                       CGL155A
     C                   EVAL      PZMsgID = 'XXX9038'                                       CGL155A
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      WCTR2 += 1
     C                   EVAL      WANOST(WCTR2) = S2NOST
     C                   ENDIF
 
     C**********         ENDIF                                                               CGL155A
 
     C                   ENDIF
 
     C                   ELSE
      ** Write to Nostro array
     C                   EVAL      WCTR2 += 1
     C                   EVAL      WANOST(WCTR2) = S2NOST
 
     C                   ENDIF
 
     C                   UPDATE    SD009562S2
 
     C                   ELSE
 
     C                   IF        S2ACNM <> *BLANKS OR
     C                             S2RPTN <> *BLANKS OR
     C                             S2RPTT <> *BLANKS
     C                   EVAL      S2ACNM = *BLANKS
     C                   EVAL      S2RPTN = *BLANKS
     C                   EVAL      S2RPTT = *BLANKS
     C                   UPDATE    SD009562S2
     C                   ENDIF
 
     C     WCTR1         CHAIN     SD009562S2
     C                   EVAL      SRLRN2 = wSRLRN2pc
     C                   UPDATE    SD009562S2
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WCTR1  += 1
 
     C                   ENDDO
 
     C                   IF        WNoDetail = 'Y'
     C                   EVAL      *IN51  = *ON                                             MD026707
     C                   EVAL      WCTR1  = 1                                               MD026707
     C                   DOW       WCTR1 <= wSRLRN2                                         MD026707
     C     WCTR1         CHAIN     SD009562S2                                               MD026707
     C                   IF        %FOUND                                                   MD026707
     C                   UPDATE    SD009562S2                                               MD026707
     C                   ENDIF                                                              MD026707
     C                   EVAL      WCTR1  += 1                                              MD026707
     C                   ENDDO                                                              MD026707
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'XXX9040'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        W#EROR = *BLANKS and
     C                             W#EROR2 = *BLANKS and
     C                             *IN03 = *OFF
 
     C                   EVAL      W1PMD  = 'CHG'
 
     C                   IF        W#ACT = 'D' AND *IN10 = *OFF
     C                   EVAL      W1RSF = 'N'
     C                   ELSE
     C                   EVAL      W1RSF = 'Y'
     C                   ENDIF
     C                   EVAL      WKIPIN = 'Y'
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkSDNGLHTD - Check if already exists in SDNGLHTD           *
      *                                                               *
      *****************************************************************
 
     C     SRChkSDNGLHTD BEGSR
 
     C                   IF        W1PMD = 'ADD'
 
     C/exec SQL
     C+ Select COUNT(*) into: WCNT from SDNGLHTD
     C***+ where NGGRPC = :S2NOGRP and NGRECI = 'D'                                          CGL155A
     C+ where NGGRPC = :S2NOGRP                                                              CGL155A
     C/end-exec
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkSDNGLDTD - Check if already exists in SDNGLDTD           *
      *                                                               *
      *****************************************************************
 
     C     SRChkSDNGLDTD BEGSR
 
     C                   EVAL      WSKIP = 'N'
     C                   IF        S1ACTN = 'A'
      ** Skip if nostro input is already exists
     C                   IF        %LOOKUP(S2NOST:WASNOST) > 0
     C                   EVAL      WSKIP  = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        WSKIP  = 'N'
     C/EXEC SQL
     C+ Select COUNT(*) into: WCNT from SDNGLDTD
     C+ where NCNCCY = :DSNCCY and NCNOSC = :DSNOSC and NCRECI = 'D'
     C/END-EXEC
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkSDFCSDTD - Check if already exists in SDFCSDTD           *
      *                                                               *
      *****************************************************************
 
     C     SRChkSDFCSDTD BEGSR
 
     C                   IF        WSKIP = 'N'
     C/EXEC SQL
     C+ Select COUNT(*) into: WCNT from SDFCSDTD
     C+ where FCCURR = :DSNCCY and FCNOTR = :DSNOSC and FCRECI = 'D'
     C/END-EXEC
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInsSDNGLDTD - Insert Nostro Group Limits                    *
      *                                                               *
      *****************************************************************
 
     C     SRInsSDNGLDTD BEGSR
 
     C                   EVAL      WCTR1 = 1
     C                   DOW       WCTR1 <= wSRLRN2
 
     C     WCTR1         CHAIN     SD009562S2
 
     C                   IF        %FOUND
 
     C                   IF        S2NOST <> *BLANKS
 
     C/EXEC SQL
     C+ Insert Into SDNGLDTD
     C+ (
     C+   NCRECI
     C+ , NCGRPC
     C+ , NCNCCY
     C+ , NCNOSC
     C+ , NCTMST
     C+ , NCORED
     C+ , NCLCD
     C+ , NCCHTP
     C+ , NCUSER
     C+ , NCZONE
     C+ )
     C+ Values
     C+ (
     C+   'D'
     C+ , :S2NOGRP
     C+ , :DSNCCY
     C+ , :DSNOSC
     C+ , :WTIME
     C+ , :BJRDNB
     C+ , :BJRDNB
     C+ , 'I'
     C+ , :PSUser
     C+ , :WZONE
     C+ )
     C/END-EXEC
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WCTR1 += 1
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdSDNGLDTD - Amend Nostro Group Limits                     *
      *                                                               *
      *****************************************************************
 
     C     SRUpdSDNGLDTD BEGSR
 
     C                   EVAL      WUPDFLG = 'N'
     C                   EVAL      WCTR1 = 1
     C                   DOW       WCTR1 <= wSRLRN2
 
     C     WCTR1         CHAIN     SD009562S2
 
     C                   IF        %FOUND
 
     C                   IF        S2NOST <> *BLANKS
 
     C                   IF        S2NOST <> S2NOSTH
 
     C                   IF        S2NOSTH <> *BLANKS
 
     C/EXEC SQL
     C+ Update SDNGLDTD set NCNCCY = :DSNCCY, NCNOSC = :DSNOSC,
     C+ NCLCD = :BJRDNB, NCUSER = :PSuser, NCCHTP = 'A',
     C+ NCTMST = :WTIME
     C+ where NCGRPC = :S1NOGRP and NCNCCY = :DSNCCYH
     C+ and NCNOSC = :DSNOSCH
     C/END-EXEC
     C                   EVAL      WUPDFLG = 'Y'
 
     C                   ELSE
 
     C/EXEC SQL
     C+ Insert Into SDNGLDTD
     C+ (
     C+   NCRECI
     C+ , NCGRPC
     C+ , NCNCCY
     C+ , NCNOSC
     C+ , NCTMST
     C+ , NCORED
     C+ , NCLCD
     C+ , NCCHTP
     C+ , NCUSER
     C+ , NCZONE
     C+ )
     C+ Values
     C+ (
     C+   'D'
     C+ , :S2NOGRP
     C+ , :DSNCCY
     C+ , :DSNOSC
     C+ , :WTIME
     C+ , :BJRDNB
     C+ , :BJRDNB
     C+ , 'I'
     C+ , :PSUser
     C+ , :WZONE
     C+ )
     C/END-EXEC
     C                   EVAL      WUPDFLG = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        S2NOSTH <> *BLANKS
 
     C/EXEC SQL
     C+ Delete FROM SDNGLDTD
     C+ where NCGRPC = :S1NOGRP and NCNCCY = :DSNCCYH
     C+ and NCNOSC = :DSNOSCH
     C/END-EXEC
     C                   EVAL      WUPDFLG = 'Y'
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WCTR1 += 1
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelSDNGLDTD - Delete Nostro Group Limits                    *
      *                                                               *
      *****************************************************************
 
     C     SRDelSDNGLDTD BEGSR
 
     C                   EVAL      WCTR1 = 1
     C                   DOW       WCTR1 <= wSRLRN2
 
     C     WCTR1         CHAIN     SD009562S2
 
     C                   IF        %FOUND
 
     C                   IF        S2NOST <> *BLANKS
 
     C                   EVAL      WTIME = %TIMESTAMP
 
     C/EXEC SQL
     C+ Update SDNGLDTD set NCRECI = '*', NCLCD = :BJRDNB,
     C+ NCUSER = :PSuser, NCCHTP = 'D', NCTMST = :WTIME
     C+ where NCGRPC = :S1NOGRP and NCNCCY = :DSNCCY
     C+ and NCNOSC = :DSNOSC
     C/END-EXEC
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WCTR1 += 1
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInsSDNGLHTD - Insert Nostro Group Limits header             *
      *                                                               *
      *****************************************************************
 
     C     SRInsSDNGLHTD BEGSR
 
     C/EXEC SQL
     C+ Insert Into SDNGLHTD
     C+ (
     C+   NGRECI
     C+ , NGGRPC
     C+ , NGGDES
     C+ , NGLCCY
     C+ , NGDLIM
     C+ , NGTMST
     C+ , NGORED
     C+ , NGLCD
     C+ , NGCHTP
     C+ , NGUSER
     C+ , NGZONE
     C+ )
     C+ Values
     C+ (
     C+   'D'
     C+ , :S2NOGRP
     C+ , :S2NODES
     C+ , :S2CURR
     C+ , :WSVAM
     C+ , :WTIME
     C+ , :BJRDNB
     C+ , :BJRDNB
     C+ , 'I'
     C+ , :PSUser
     C+ , :WZONE
     C+ )
     C/END-EXEC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdSDNGLHTD - Update Nostro Group Limits header             *
      *                                                               *
      *****************************************************************
 
     C     SRUpdSDNGLHTD BEGSR
 
     C                   IF        WUPDFLG = 'Y' OR
     C                             (S2NODES <> WSVNODES OR
     C                              S2DLMT  <> WSVDLMT  OR
     C                              S2CURR  <> WSVCURR)
 
     C/EXEC SQL
     C+ UPDATE SDNGLHTD SET NGGDES = :S2NODES, NGLCCY = :S2CURR,
     C+ NGDLIM = :WSVAM, NGTMST = :WTIME, NGLCD = :BJRDNB,
     C+ NGCHTP = 'A', NGUSER = :PSuser
     C+ where NGGRPC = :S1NOGRP
     C/END-EXEC
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelSDNGLHTD - Delete Nostro Group Limits header             *
      *                                                               *
      *****************************************************************
 
     C     SRDelSDNGLHTD BEGSR
 
     C/EXEC SQL
     C+ UPDATE SDNGLHTD SET NGRECI = '*', NGLCD = :BJRDNB,
     C+ NGUSER = :PSuser, NGCHTP = 'D', NGTMST = :WTIME
     C+ where NGGRPC = :S1NOGRP
     C/END-EXEC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelReq - Process Delete Request                             *
      *                                                               *
      *****************************************************************
 
     C     SRDelReq      BEGSR
 
      ** Delete Nostro Group
 
     C                   EXSR      SRDelete
 
     C                   IF        W#EROR <> *BLANKS
 
      ** Delete unsuccessful
 
     C                   EVAL      *IN32 = *ON
     C                   MOVEA     '11'          *IN(83)
     C                   EXSR      SRMoveSfl1
     C                   ELSE
 
      ** Blank out record and protect from entry
 
     C                   EXSR      SRClrScrn
     C                   EVAL      *IN84 = *OFF
 
      ** Reload subfile
 
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      S1POS1 = *Blanks
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAmdReq - Process Update Request                             *
      *                                                               *
      *****************************************************************
 
     C     SRAmdReq      BEGSR
 
      ** Amend Nostro Group
 
     C                   EXSR      SRAmend
 
     C                   IF        W#EROR <> *BLANKS or *IN03 = *ON
     C                   EVAL      *IN32 = *ON
     C                   MOVEA     '11'          *IN(83)
 
      ** Reset subfile record if changed record
 
     C                   EXSR      SRMoveSfl1
     C                   ELSE
 
      ** Enable entry
 
     C                   EVAL      *IN84 = *OFF
     C                   ENDIF
 
      ** Update Database
 
     C                   IF        (W#EROR =*BLANKS) AND (WKIPIN = 'Y')
     C                             and *IN03 = *OFF
     C                   EXSR      SRUpdate
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMode - Switch Between *ADD and *CHANGE Modes                *
      *                                                               *
      *****************************************************************
 
     C     SRMode        BEGSR
 
      ** Switch between *ADD/*CHANGE modes
 
     C                   IF        W1PMD <> 'ADD'
     C                   EVAL      W1PMD = 'ADD'
     C                   ELSE
     C                   EVAL      W1PMD = 'CHG'
     C                   ENDIF
 
     C                   EVAL      SPOSN = *BLANKS
 
     C                   EXSR      SRReload
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReload - Request Subfile Reload                             *
      *                                                               *
      *****************************************************************
 
     C     SRReload      BEGSR
 
      ** Request subfile reload
 
     C                   EVAL      W1RSF = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClrScrn - Initialise Subfile Record                         *
      *                                                               *
      *****************************************************************
 
     C     SRClrScrn     BEGSR
 
      ** Initialise subfile record
 
     C                   EVAL      S1ACTN  = *BLANKS
     C                   EVAL      S1NOGRP = *BLANKS
     C                   EVAL      S1NODES = *BLANKS
     C                   EVAL      S1DLMT  = *BLANKS
     C                   EVAL      S1CURR  = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClrSfl2 - Initialise Subfile Record for Screen 2            *
      *                                                               *
      *****************************************************************
 
     C     SRClrSfl2     BEGSR
 
      ** Initialise subfile record
 
     C                   EVAL      S2NOST = *BLANKS
     C                   EVAL      S2NOSTH = *BLANKS
     C                   EVAL      S2ACNM = *BLANKS
     C                   EVAL      S2RPTN = *BLANKS
     C                   EVAL      S2RPTT = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMoveSfl1 - Transfer Records from SDNGLHTD to Subfile        *
      *                                                               *
      *****************************************************************
 
     C     SRMoveSfl1    BEGSR
 
      ** Move SDNGLHTD fields to subfile
 
     C                   EVAL      S1NOGRP = A_NGGRPC
     C                   EVAL      S1NODES = A_NGGDES
     C                   EVAL      S1CURR = A_NGLCCY
     C                   IF        A_NGDLIM <> 0
     C/exec sql
     C+ select * into :SDCURR from SDCURRPD
     C+ where A6CYCD = :A_NGLCCY
     C/end-exec
 
     C                   IF        SQLCOD = 0
 
      ** Edit the amount
 
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      A_NGDLIM      ZFLD15
     C                   EVAL      ZDECS = A6NBDP
 
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM      *BLANKS       ZECODE
     C                   PARM                    ZOUT21
 
     C                   EVAL      S1DLMT = %SUBST(ZOUT21:5:16)
 
     C                   ENDIF
     C                   ENDIF
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMoveSfl2 - Transfer Records from SDNGLDTD to Subfile        *
      *                                                               *
      *****************************************************************
 
     C     SRMoveSfl2    BEGSR
 
      ** Nostro Code validation
      ** ----------------------
 
     C/exec sql
     C+ select * into :SDNOST from SDNOSTPD
     C+ where A7CYCD = :DSNCCY AND
     C+ A7NONB = :DSNOSC
     C/end-exec
 
     C                   IF        SQLCOD = 0
     C                   EVAL      NCUST = A7CUST
     C                   EVAL      NACOD = A7ACCD
     C                   MOVE      A7ACSN        NACSQ
     C                   EVAL      NBRCA = A7BRCD
 
     C                   EVAL      S2NOSTH = S2NOST
 
     C/exec sql
     C+ select * into :SDACCT from ACCNTAB
     C+ where CNUM = :NCUST AND CCY = :DSNCCY AND
     C+ ACOD = :NACOD AND ACSQ = :NACSQ AND
     C+ BRCA = :NBRCA
     C/end-exec
 
      ** Account Name
 
     C                   IF        SQLCOD = 0
     C                   EVAL      S2ACNM = A_ANAM
     C                   ENDIF
 
     C/exec sql
     C+ select * into :SDCUST from SDCUSTPD
     C+ where BBCUST = :NCUST
     C/end-exec
 
     C                   IF        SQLCOD = 0
     C                   EVAL      S2RPTN = BBCRNM
     C                   EVAL      S2RPTT = BBCRTN
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      *IN51  = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'XXX9037'
     C                   EXSR      SRZasnms
 
     C                   ENDIF
 
     C                   IF        S1ACTN = 'A'
     C                   EVAL      WCTR3 += 1
     C                   EVAL      WASNOST(WCTR3) = B_NCNCCY + B_NCNOSC
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkNOSTRO - Check Nostro account                            *
      *                                                               *
      *****************************************************************
 
     C     SRChkNOSTRO   BEGSR
 
     C                   IF        S2NOST = '?'                                              CGL155A
                                                                                             CGL155A
     C                   CALL      'AONOSTR0'                                                CGL155A
     C                   PARM      *BLANKS       PRTCD                                       CGL155A
     C                   PARM      '*VERIFY'     POPTN                                       CGL155A
     C                   PARM      *BLANKS       PCUST                                       CGL155A
     C                   PARM                    DSNCCY                                      CGL155A
     C                   PARM      *BLANKS       PACCN                                       CGL155A
     C                   PARM      *BLANKS       PACSN                                       CGL155A
     C                   PARM                    DSNOSC                                      CGL155A
     C                   PARM      *BLANKS       PBRCD                                       CGL155A
     C                   PARM      *BLANKS       PCSSN                                       CGL155A
     C                   PARM      *BLANKS       PPNOI                                       CGL155A
     C     SDNOST        PARM      *BLANKS       DSFDY                                       CGL155A
                                                                                             CGL155A
     C*                  IF        PRTCD = *BLANKS                                           CGL155A
     C*                  EVAL      DSNCCY = A7CYCD                                           CGL155A
     C*                  EVAL      DSNCCY = A7NONB                                           CGL155A
     C*                  ENDIF                                                               CGL155A
                                                                                             CGL155A
     C                   ENDIF                                                               CGL155A
     C/exec sql
     C+ select * into :SDNOST from SDNOSTPD
     C+ where A7CYCD = :DSNCCY AND
     C+ A7NONB = :DSNOSC
     C/end-exec
 
     C                   IF        SQLCOD = 0
     C                   EVAL      NCUST = A7CUST
     C                   EVAL      NACOD = A7ACCD
     C                   MOVE      A7ACSN        NACSQ
     C                   EVAL      NBRCA = A7BRCD
 
     C/exec sql
     C+ select * into :SDACCT from ACCNTAB
     C+ where CNUM = :NCUST AND CCY = :DSNCCY AND
     C+ ACOD = :NACOD AND ACSQ = :NACSQ AND
     C+ BRCA = :NBRCA
     C/end-exec
 
      ** Account Name
 
     C                   IF        SQLCOD = 0
     C                   EVAL      S2ACNM = A_ANAM
     C                   ENDIF
 
     C/exec sql
     C+ select * into :SDCUST from SDCUSTPD
     C+ where BBCUST = :NCUST
     C/end-exec
 
      ** Report Name and Town
 
     C                   IF        SQLCOD = 0
     C                   EVAL      S2RPTN = BBCRNM
     C                   EVAL      S2RPTT = BBCRTN
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      *IN51  = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'XXX9037'
     C                   EXSR      SRZasnms
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Create Nostro Group Details                         *
      *                                                               *
      *****************************************************************
 
     C     SRWrite       BEGSR
 
     C                   EVAL      W#EROR = *BLANKS
 
      ** Create Create Nostro Group Details
 
     C                   IF        WSVAM = 0 AND A_NGGRPC <> *BLANKS
     C                   EVAL      WSVAM = 999999999999999
     C                   ENDIF
     C                   EVAL      WTIME = %TIMESTAMP
 
      ** Check for duplicate primary key
 
     C/EXEC SQL
     C+ SELECT *
     C+ into :NostroGHDS
     C+ from SDNGLHTD
     C+ where NGGRPC = :S1NOGRP and
     C+       NGRECI = 'D'
     C/END-EXEC
 
     C                   IF        %Subst(SQLState:1:2) <> '02'
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0017'
     C                   EXSR      SRZasnms
     C                   ELSE
 
     C/EXEC SQL
     C+ Insert Into SDNGLHTD
     C+ (
     C+   NGRECI
     C+ , NGGRPC
     C+ , NGGDES
     C+ , NGLCCY
     C+ , NGDLIM
     C+ , NGTMST
     C+ , NGORED
     C+ , NGLCD
     C+ , NGCHTP
     C+ , NGUSER
     C+ , NGZONE
     C+ )
     C+ Values
     C+ (
     C+   'D'
     C+ , :S2NOGRP
     C+ , :S2NODES
     C+ , :S2CURR
     C+ , :WSVAM
     C+ , :WTIME
     C+ , :BJRDNB
     C+ , :BJRDNB
     C+ , 'I'
     C+ , :PSUser
     C+ , :WZONE
     C+ )
     C/END-EXEC
      *
     C                   If        (SQLCODE <> 0)
      * Write error detected
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      *IN03 = *ON
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelete - Delete Nostro Group                                *
      *                                                               *
      *****************************************************************
 
     C     SRDelete      BEGSR
 
     C                   EXSR      SRInitHdr2
 
     C                   EXSR      SRInitSfl2
 
     C/EXEC SQL
     C+    SELECT *
     C+ into :NostroGDDS
     C+ from SDNGLDTD
     C+ where NCGRPC = :S1NOGRP AND NCRECI = 'D'
     C/END-EXEC
 
      ** Record already deleted
 
     C                   If        %Subst(SQLState:1:2) = '02'
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7602'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      S2MODE = 'DELETE'
 
     C                   EVAL      S2NOGRP = S1NOGRP
     C                   EVAL      S2NODES = S1NODES
     C                   EVAL      S2DLMT = S1DLMT
     C                   EVAL      S2CURR = S1CURR
 
      ** Reset field error indicators.
 
     C                   EVAL      *IN36 = *OFF
     C                   EVAL      *IN37 = *OFF
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN39 = *ON
 
     C                   EXSR      SRBldSfl2
 
     C                   EVAL      W1RSF = 'N'
 
     C                   DOW       *IN03 = *OFF and
     C                             *IN12 = *OFF and                                         MD026948
     C                             W1RSF = 'N'
 
      ** Display Screen 2
 
     C                   EXSR      SRDspSfl2
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   EVAL      *IN39 = *OFF
 
     C                   EVAL      W1RSF = 'N'
     C                   IF        W#ACT = 'E'
     C                   EVAL      *IN38 = *OFF
     C                   ENDIF
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
      ** Set record data changed flag
 
     C                   EVAL      WCUST = 'N'
 
     C                   IF        *IN10 = *ON
 
     C                   EVAL      WTIME = %TIMESTAMP
     C                   EXSR      SRDelSDNGLDTD
     C                   EXSR      SRDelSDNGLHTD
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAddReq - Update Nostro Group                                *
      *                                                               *
      *****************************************************************
 
     C     SRAddReq      BEGSR
 
     C                   EXSR      SRInitHdr2
 
     C                   EXSR      SRInitSfl2
 
     C                   EVAL      S2MODE = 'INSERT '
     C                   EVAL      W1PMD  = 'ADD'
 
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN37 = *OFF
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN39 = *OFF
 
     C                   EXSR      SRLoadInpScr
     C                   EVAL      *IN91 = *ON
     C                   EVAL      *IN92 = *OFF
 
     C                   EVAL      W1RSF = 'N'
 
     C                   DOW       *IN03 = *OFF and
     C                             *IN12 = *OFF and                                         MD026948
     C                             W1RSF = 'N'
 
      ** Display Screen 2
 
     C                   EXSR      SRDspSfl2
 
     C                   ENDDO
 
     ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
     C                   IF        *IN03 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAmend  - Update Nostro Group                                *
      *                                                               *
      *****************************************************************
 
     C     SRAmend       BEGSR
 
     C                   EXSR      SRInitHdr2
 
 
      ** Initialise & load blank subfile page
 
     C                   EXSR      SRInitSfl2
 
     C/EXEC SQL
     C+ SELECT *
     C+ into :NostroGDDS
     C+ from SDNGLDTD
     C+ where NCGRPC = :S1NOGRP AND NCRECI = 'D'
     C/END-EXEC
 
      ** Record not found
 
     C                   If        %Subst(SQLState:1:2) = '02'
 
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7605'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ** Move to display file fields
 
     C                   EVAL      S2MODE = 'AMEND  '
     C                   EVAL      S2NOGRP = S1NOGRP
     C                   EVAL      S2NODES = S1NODES
     C                   EVAL      S2DLMT = S1DLMT
     C                   EVAL      S2CURR = S1CURR
     C                   EVAL      WSVNODES = S1NODES
     C                   EVAL      WSVDLMT = S1DLMT
     C                   EVAL      WSVCURR = S1CURR
     C                   EVAL      WUPDFLG = 'N'
 
      ** Reset field error indicators.
 
     C                   EVAL      *IN36 = *OFF
     C                   EVAL      *IN37 = *ON
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN39 = *OFF
 
     C                   EXSR      SRBldSfl2
      ** Add new lines
     C                   EXSR      SRLoadInpScr
      ** Position cursor
     C                   EVAL      SRLRN2 = 1
     C     SRLRN2        CHAIN     SD009562S2
     C                   IF        %FOUND
     C                   UPDATE    SD009562S2
     C                   ENDIF
      ** Rolldown
     C                   EVAL      *IN92  = *OFF
 
     C                   ENDIF
 
     C                   EVAL      W1RSF = 'N'
     C                   DOW       *IN03 = *OFF and
     C                             *IN12 = *OFF and                                         MD026948
     C                             W1RSF = 'N'
 
      ** Display Screen 2
 
     C                   EXSR      SRDspSfl2
 
     C                   ENDDO
 
     ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
     C                   IF        *IN03 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZasnms - Message Handling Subroutine                        *
      *                                                               *
      *****************************************************************
 
     C     SRZasnms      BEGSR
 
     C                   CALL      'ZA0340'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgID
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZasnmsd - Handles the display of error messages with        *
      *             substitution values.                              *
      *                                                               *
      * Called By: SRScrn2v subroutine                                *
      *                                                               *
      * Calls:                                                        *
      * ZA0350   - Add message to pgm subfile message queue.          *
      *                                                               *
      *                                                               *
      *****************************************************************
 
     C     SRZasnmsd     BEGSR
 
     C                   CALL      'ZA0350'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgID
     C                   PARM                    PZMsgDta
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnd - End Program                                           *
      *                                                               *
      *****************************************************************
 
     C     SREnd         BEGSR
                                                                                            MD026866
     C********           COMMIT                                                   MD026866 MD026866A
 
      ** If selection mode and F3 has been pressed
      ** Terminate program
 
     C                   EVAL      *INLR = *ON
 
      ** Exit program
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZedit - Subroutine to formate numeric field                 *
      *                                                               *
      *****************************************************************
 
     C     SRZedit       BEGSR
 
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Receive entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    PMODE
 
     C     PPAR1         PLIST
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    PSCRF
     C                   PARM                    PNDEC
     C                   PARM                    PNDIG
     C                   PARM      *BLANKS       PRVAL
 
      ** Define LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SD009562'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
 
      ** Define ZMUSER
 
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
 
     C/exec sql
     C+ select * into :SDBANK from SDBANKPD
     C/end-exec
 
     C                   IF        SQLCOD <> 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBPGM  = 'SD009562'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C/exec sql
     C+ select * into :SDRETL from SDRETLPD
     C/end-exec
 
      ** Database error
 
     C                   IF        SQLCOD <> 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDRETLPD'
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBASE  = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Get Zone
 
     C                   CALL      'GOGETZONE'
     C                   PARM      *BLANKS       PZRTCD
     C                   PARM      *BLANKS       PZERMS
     C                   PARM      'N'           PZFCHK
     C                   PARM      *BLANKS       PZZONE
     C                   PARM      *BLANKS       PZSHTC
     C                   PARM      *ZERO         PZRDNB
     C                   PARM      *ZERO         PZDNWD
     C                   PARM      *BLANKS       PZBCCY
     C                   PARM      *ZERO         PZNJOB
      *
     C                   IF        PZRTCD = *BLANKS
     C                   EVAL      WZONE = PZZONE
     C                   ELSE
      *
     C                   IF        PZRTCD = '*ERROR'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Open files for update
 
     C                   OPEN      SD009562DF
 
     C/exec sql
     C+ declare NostroGH Scroll Cursor
     C+  for select *
     C+  from SDNGLHTD
     C***where NGRECI = 'D'                                                                  CGL155A
     C+  where NGRECI = 'D' and NGGRPC >= :S1POS1                                            CGL155A
     C+  order by
     C+  NGGRPC
     C/end-exec
 
     C/exec sql
     C+ open NostroGH
     C/end-exec
 
     C                   EVAL      WSFPG  = 12
     C                   EVAL      WSFPG2 = 10
 
      ** Set to *CHANGE mode
 
     C                   EVAL      W1PMD = 'CHG'
 
      ** Initialise subfile control
 
     C                   EVAL      SPOSN = *BLANKS
     C                   EVAL      S1RUNA = BJMRDT
     C                   EVAL      S1PGMQ = PSProcName
     C                   EVAL      S1WSID = PSUser
 
      ** Initialise subfile control
 
     C                   EVAL      S1POS1 = *BLANKS
 
     C                   ENDSR
                                                                                            MD027374
      *****************************************************************                     MD027374
      /EJECT                                                                                MD027374
      *****************************************************************                     MD027374
      *                                                               *                     MD027374
      *  ACTCHECK - Action Code Authorization Check                   *                     MD027374
      *                                                               *                     MD027374
      *****************************************************************                     MD027374
                                                                                            MD027374
     C     ACTCHECK      BEGSR                                                              MD027374
                                                                                            MD027374
      ** If not multi-branching, check authority to only action code.                       MD027374
                                                                                            MD027374
     C                   IF        BJSBRC <> *BLANK                                         MD027374
                                                                                            MD027374
     C                   CALL      'ZVACTU'                                                 MD027374
     C                   PARM      S1ACTN        PActn                                      MD027374
     C                   PARM                    PError                                     MD027374
                                                                                            MD027374
     C                   IF        PError <> *ZERO                                          MD027374
     C                   EVAL      W1RSF = 'Y'                                              MD027374
     C                   EVAL      PZMsgID = 'XXX9032'                                      MD027374
     C                   EXSR      SRZasnms                                                 MD027374
     C                   EVAL      *IN40 = *ON                                              MD027374
     C                   ENDIF                                                              MD027374
                                                                                            MD027374
     C                   ELSE                                                               MD027374
                                                                                            MD027374
      ** If multi-branching, check authority to user's default branch.                      MD027374
                                                                                            MD027374
     C                   CALL      'ZVACTBU'                                                MD027374
     C                   PARM      S1ACTN        PActn                                      MD027374
     C                   PARM      DBRN          PBrc                                       MD027374
     C                   PARM                    PError                                     MD027374
                                                                                            MD027374
     C                   IF        PError = 1                                               MD027374
     C                   EVAL      W1RSF = 'Y'                                              MD027374
     C                   EVAL      PZMsgID = 'XXX9032'                                      MD027374
     C                   EXSR      SRZasnms                                                 MD027374
     C                   EVAL      *IN40 = *ON                                              MD027374
     C                   ENDIF                                                              MD027374
                                                                                            MD027374
     C                   IF        PError = 2                                               MD027374
     C                   EVAL      W1RSF = 'Y'                                              MD027374
     C                   EVAL      PZMsgID = 'XXX9032'                                      MD027374
     C                   EXSR      SRZasnms                                                 MD027374
     C                   EVAL      *IN40 = *ON                                              MD027374
     C                   ENDIF                                                              MD027374
     C                   ENDIF                                                              MD027374
                                                                                            MD027374
     C                   ENDSR                                                              MD027374
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
                                                                                            MD026866
     C                   ROLBK                                                              MD026866
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
