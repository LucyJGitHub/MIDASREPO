     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF MNCP Pools Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009563 - Midas OF MNCP Pools Maintenance                   *
      *                                                               *
      *  Function:  This program maintains the MNCP Pools             *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL176             Date 20Jul15               *
      *                 MD031323           Date 27Nov14               *
      *                 CGL159  *CREATE    Date 27Aug14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL176 - Optimisation of Nostro Balances by Company          *
      *  MD031323 - Pool is being created automatically after         *
      *             selecting a Nostro using '?'                      *
      *  CGL159 - Optimisation of Cash Positions                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Forecast Static Data Display File
     FSD009563DFCF   E             WORKSTN USROPN
     F                                     SFILE(SD009563S1:SRLRN)
     F                                     SFILE(SD009563S2:SRLRN2)
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

      ** External data structure for Switchable Feature databse                             CGL176
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                CGL176

      ** External data structure for Branch Details                                         CGL176
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                CGL176
     D QQDFAC1       E                     EXTFLD(QQDFAC)                                   CGL176

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

     D MNCPGHDS      E DS                  EXTNAME(SDMNPHTD)
     D                                     PREFIX(A_)

     D MNCPGDDS      E DS                  EXTNAME(SDMNPDTD)
     D                                     PREFIX(B_)

     D DSFDY         E DS                  EXTNAME(DSFDY)

     D S2NOST          DS
     D  DSNCCY                 1      3
     D  DSNOSC                 4      5
     D  DSNOST                 1      5
     D S2NOSTH         DS
     D  DSNCCYH                1      3
     D  DSNOSCH                4      5
     D  DSNOSTH                1      5

     D WANOST          S              5A   DIM(1000) ASCEND
     D WASNOST         S              5A   DIM(1000) ASCEND

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1
     D CAIN89          S              1

      ** Database error workfields
     D PRTCD           S              7
     D POPTN           S              7
     D PCUST           S              6
     D PACCN           S             10
     D PACSN           S              2
     D PBRCD           S              3
     D PCSSN           S             10
     D PPNOI           S              1

      ** Message file workfields - Parameters list for ZA0340 / ZA0350
     D PZMsgFile       S             10A   INZ('GBSDUSRMSG')
     D PZMsgID         S             10
     D PZMsgDta        S             45A

      ** General workfields
     D CAIN81          S              1
     D PMODE           S              1
     D W#ACT           S              1
     D WKIPIN          S              1
     D WLRCD           S              4  0
     D WPOSN           S              5
     D WRCTR           S              5  0
     D WRCTR2          S              5  0
     D DetailCtr       S              7  0
     D PoolWrkFld      S             10
     D WSFPG           S              3  0
     D WSFPG2          S              3  0
     D W1PMD           S              3
     D W1RSF           S              1
     D W#EROR          S              1
     D W#EROR2         S              1
     D WTIME           S               Z
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
     D WSVPDES         S             30A
     D WSVPCUR         S              3A
     D WUPDFLG         S              1A
     D PActn           S              1A
     D PBrc            S              3A
     D PError          S              1  0
     D NCUST           S              6A
     D NACOD           S             10A
     D NACSQ           S              2A
     D NBRCA           S              3A
     D CGL176          S              1A                                                    CGL176
     D @RRN            S              4S 0                                                  CGL176
     D PSARD           S              6A                                                    CGL176
     D S@CMPY          S              3A                                                    CGL176
     D S#CMPY          S              3A                                                    CGL176

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

      ** Main Program

     C                   DO        *HIVAL

      ** Initialise and load subfile page
     C                   IF        *IN32 = *OFF AND *IN40 = *OFF
     C                   EXSR      SRBldSfl1
     C                   ENDIF

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
     C                   WRITE     SD009563C1
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
     C+ close MNCPGH
     C/end-exec

     C/exec sql
     C+ open MNCPGH
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from MNCPGH
     C+ into :MNCPGHDS
     C/end-exec

     C                   ELSE
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF

     C                   If        %Subst(SQLState:1:2) = '02'
     C                   EVAL      *IN82 = *ON
     C                   ENDIF

      ** Save previous selector values

     C     *LIKE         DEFINE    S1POLS        WZPOLS
     C                   EVAL      WZPOLS = S1POLS

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
     C+ declare MNCPGD   Scroll Cursor
     C+  for select *
     C+  from SDMNPDTD
     C+ where P2POOL = :S1POOL  and P2RECI = 'D'
     C/end-exec

     C/exec sql
     C+ open MNCPGD
     C/end-exec

      ** If CHANGE mode, then position file

     C                   EVAL      *IN92 = *OFF

     C                   IF        W1PMD <> 'ADD'
     C                   EVAL      WPOSN = SPOSN

      ** Setup key

     C/exec SQL
     C+ close MNCPGD
     C/end-exec

     C/exec sql
     C+ open MNCPGD
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from MNCPGD
     C+ into :MNCPGDDS
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
     C+ from MNCPGH
     C+ into :MNCPGHDS
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from MNCPGH
     C+ into :MNCPGHDS
     C/end-exec

     C                   ENDIF

      ** Start at previous highest record in SFL

     C                   EVAL      SRLRN = WLRCD
     C                   EVAL      WRCTR = 1

      ** Load next subfile page

     C                   DOW       %Subst(SQLState:1:2) <> '02'
     C                             and WRCTR <= WSFPG

     C                   ADD       1             SRLRN
     C                   EVAL      *IN32 = *OFF

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

     C                   WRITE     SD009563S1

      ** End of File

     C                   IF        W1PMD <> 'ADD'

     C/exec SQL
     C+ fetch next
     C+ from MNCPGH
     C+ into :MNCPGHDS
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
     C+ from MNCPGD
     C+ into :MNCPGDDS
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from MNCPGD
     C+ into :MNCPGDDS
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

     C                   EVAL      S2NOST = B_P2NOST
     C                   EXSR      SRMoveSfl2

      ** Output to subfile

     C                   ADD       1             WRCTR2               81
     C                   EVAL      *IN91 = *ON

      ** If SFLRCD invalid, note that errors present

     C                   IF        *IN83 = *ON and *IN40 = '0'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF

     C                   WRITE     SD009563S2

     C                   ELSE
     C                   SUB       1             SRLRN2
     C                   ENDIF

      ** End of File

     C                   IF        W1PMD <> 'ADD'

     C/exec SQL
     C+ fetch next
     C+ from MNCPGD
     C+ into :MNCPGDDS
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
     C                   EVAL      *IN88 = *OFF

      ** PUTOVR unless conditioned fields change

     C                   IF        *IN89 <> CAIN89 OR *IN81 <> CAIN81
     C                   EVAL      *IN86 = *OFF
     C                   ENDIF

     C                   EVAL      CAIN89 = *IN89
     C                   EVAL      CAIN81 = *IN81

      ** Display appropriate Header depending upon Mode whether it is
      ** Enquiry or Maintenance

     C                   TIME                    S1TIME
     C                   WRITE     SD009563C3
     C                   WRITE     SD009563F1
     C                   EXFMT     SD009563C1

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

     C                   EVAL      *IN88 = *ON
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
     C                   WRITE     SD009563C3
     C                   WRITE     SD009563F1
     C                   EXFMT     SD009563C2

      ** Clear messages from program message queue

     C                   CALL      'ZA0250'
     C                   EVAL      W#EROR = *BLANKS
     C                   EVAL      W#EROR2 = *BLANKS
     C                   MOVEA     '0'           *IN(40)
     C                   MOVEA     '00'          *IN(42)

     C                   IF        @#SFRC <> 0
     C                   EVAL      wSRLRN2pc = @#SFRC
     C                   ENDIF

     C                   IF        *IN03 = *ON
     C                   LEAVE
     C                   ENDIF

     C                   IF        *IN12 = *ON
     C                   LEAVE
     C                   ENDIF

     C                   IF        *IN27 = *ON
      *
     C                   EXSR      SRValInpScr
      *
      * Load page with data only if not Insert
     C                   IF        S1ACTN <> 'I'
      *
      * Backup the pointers if not Insert
     C                   IF        S1ACTN = 'A'
     C                   Z-ADD     WSRLRN2       SRLRN2
     C     1             ADD       WSRLRN2       WSRLRN3           4 0
     C                   ENDIF
      *
     C                   EXSR      SRLoadSfl2
      *
     C                   ENDIF
      *
     C                   IF        S1ACTN = 'I' OR
     C                             (S1ACTN = 'A' AND
     C                             (%REM(SRLRN2:10)>0 OR
     C                             (%REM(SRLRN2:10)=0 AND *IN92 = *ON ) OR
     C                             (%REM(SRLRN2:10)=0 AND *IN92 = *OFF AND
     C                             WRCTR2 = 1))
     C                             )
      *
     C                   EVAL      *IN51  = *OFF
     C                   EXSR      SRLoadInpScr
      *
     C                   IF        S1ACTN = 'A'
      ** Reposition cursor on Amend
     C     WSRLRN3       CHAIN     SD009563S2
     C                   IF        %FOUND
     C                   UPDATE    SD009563S2
     C                   ENDIF
     C                   EVAL      *IN92  = *OFF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE

     C                   IF        *IN38 <> *ON AND
     C                             *IN39 <> *ON

     C                   EXSR      SRValInpScr

     C                   EXSR      SRValSfl2
     C                   IF        *IN40 = *ON
      ** Reposition cursor on Amend
     C     1             CHAIN     SD009563S2
     C                   IF        %FOUND
     C                   MOVE      *IN51         WIN51             1
     C                   IF        *IN52 = *ON
     C                   EVAL      *IN51 = *ON
     C                   EVAL      *IN52 = *OFF
     C                   ENDIF
     C                   UPDATE    SD009563S2
     C                   MOVE      WIN51         *IN51
     C                   ENDIF
      *
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
     C                             OR WZPOLS <> S1POLS
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
     C                   EXSR      SRInsSDMNPHTD
     C                   IF        SQLCOD = 0
     C                   EXSR      SRInsSDMNPDTD
     C                   ENDIF

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
     C                   EXSR      SRUpdSDMNPDTD
     C                   EXSR      SRUpdSDMNPHTD

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

      ** Create MNCP pool Details

     C                   EVAL      *IN71 = *OFF
     C                   EVAL      *IN73 = *OFF
     C                   EVAL      *IN70 = *ON
     C                   EVAL      *IN89 = *ON
     C                   EVAL      *IN51 = *OFF
     C                   EVAL      W#ACT = *BLANKS
     C                   Z-ADD     0             WRLRN             5 0
     C                   IF        CGL176 = 'Y'                                             CGL176
     C                   EVAL      S@CMPY = *BLANKS                                         CGL176
     C                   ENDIF                                                              CGL176

      ** Process Amend/Delete Request

     C                   IF        W1PMD = 'CHG' and *IN09 <> *ON

     C                   DOW       *IN03 = *OFF and
     C                             W1RSF = 'N' and WLRCD <> *ZEROS

     C                   Z-ADD     0             WRLRN
     C                   EVAL      WCTR  = 1
     C                   DOW       WCTR <= wSRLRN

     C                   EVAL      *IN32 = *OFF
     C     WCTR          CHAIN     SD009563S1

     C                   IF        %FOUND

     C                   IF        S1ACTN <> ' '

      ** Invalid Action Code

     C                   IF        (S1ACTN <> 'E' and S1ACTN <> 'D' and
     C                             S1ACTN <> 'A')
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      PZMsgID = 'XXX9031'
     C                   EXSR      SRZasnms
     C     WCTR          CHAIN     SD009563S1
     C                   IF        %FOUND
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN40 = *ON
     C                   UPDATE    SD009563S1
     C                   ENDIF
     C                   EVAL      WRLRN = SRLRN
     C                   LEAVE
     C                   ELSE
      *
     C                   EVAL      W#ACT = S1ACTN
     C                   IF        S1ACTN = 'E'
     C                   EVAL      *IN40 = *OFF
     C                   EXSR      ACTCHECK
     C                   IF        *IN40 = *OFF
     C                   EXSR      SREnqReq
     C                   ELSE
     C                   EVAL      *IN32 = *ON
     C                   UPDATE    SD009563S1
     C                   EVAL      WRLRN = SRLRN
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF

      ** Check if Delete
     C                   IF        S1ACTN = 'D' and PMODE = 'M'

     C                   EVAL      *IN40 = *OFF
     C                   EXSR      ACTCHECK

     C                   IF        *IN40 = *OFF
     C                   EXSR      SRDelReq
     C                   COMMIT
     C                   ELSE
     C                   EVAL      *IN32 = *ON
     C                   UPDATE    SD009563S1
     C                   EVAL      WRLRN = SRLRN
     C                   LEAVE

     C                   ENDIF
     C                   ENDIF

      ** Check if Amend
     C                   IF        S1ACTN = 'A' and PMODE = 'M'

     C                   EVAL      *IN40 = *OFF
     C                   EXSR      ACTCHECK

     C                   IF        *IN40 = *OFF

      ** Save current position of subfile
     C                   EXSR      SRAmdReq
     C                   COMMIT
     C                   EVAL      PoolWrkFld = S1POOL
     C                   EXSR      SRUpdatCtr
     C                   ELSE
     C                   EVAL      *IN32 = *ON
     C                   UPDATE    SD009563S1
     C                   EVAL      WRLRN = SRLRN
     C                   LEAVE

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   IF        *IN03 = *ON
     C                   LEAVE
     C                   ENDIF


     C     WCTR          CHAIN     SD009563S1
     C                   IF        %FOUND
     C                   IF        *IN40 = *OFF AND *IN32 = *OFF
     C                   EVAL      S1ACTN = *BLANKS
     C                   ELSE
     C                   EVAL      *IN32 = *ON
     C                   ENDIF
     C                   UPDATE    SD009563S1
     C                   ENDIF

     C                   ELSE
      *
     C     WCTR          CHAIN     SD009563S1
     C                   IF        %FOUND
     C                   EVAL      *IN32 = *OFF
     C                   EVAL      S1ACTN = *BLANKS
     C                   UPDATE    SD009563S1
     C                   ENDIF
      *
     C                   ENDIF

     C                   ENDIF

     C                   IF        WRLRN = 0 AND
     C                             (*IN40 = *ON or *IN32 = *ON)
     C                   EVAL      WRLRN = SRLRN
     C                   ENDIF

     C                   EVAL      WCTR  += 1
     C                   ENDDO
     C                   EVAL      W1RSF = 'Y'

     C                   ENDDO

      ** If subfile is empty, resend message

     C                   IF        WLRCD = *ZEROS
     C                   EVAL      PZMsgID = 'USR7590'
     C                   EXSR      SRZasnms
     C                   ADD       2             WLOOP
     C                   ELSE
     C                   EVAL      WCTR  += 1
     C                   DOW       WCTR <= wSRLRN
     C     WCTR          CHAIN     SD009563S1
     C                   EVAL      *IN32 = *OFF
     C                   UPDATE    SD009563S1
     C                   EVAL      WCTR  += 1
     C                   ENDDO
     C                   ENDIF

     C                   IF        WRLRN > 0
     C                   EVAL      SRLRN = WRLRN
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
     C                   COMMIT
     C                   EVAL      PoolWrkFld = S2POLS
     C                   EXSR      SRUpdatCtr
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

     C                   EVAL      W1RSF = 'N'
     C                   IF         *IN40 = *OFF AND *IN32 = *OFF
     C                   ADD       1             WLOOP             1 0
     C                   IF        WLOOP > 1
     C                   EVAL      W1RSF = 'Y'
     C                   Z-ADD     0             WLOOP
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     0             WLOOP
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
     C+ into :MNCPGDDS
     C+ from SDMNPDTD
     C+ where P2POOL = :S1POOL  and P2RECI = 'D'
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
     C                   EVAL      S2POLS  = S1POOL
     C                   EVAL      S2PDES  = S1PDES
     C                   EVAL      S2PCUR = S1PCUR

      ** Initialise & load blank subfile page


      ** Reset field error indicators.

     C                   EVAL      *IN36 = *OFF
     C                   EVAL      *IN37 = *OFF
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN39 = *OFF

     C                   EXSR      SRBldSfl2

     C                   DOW       *IN03 = *OFF and
     C                             *IN12 = *OFF and
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
     C                   EVAL      S2POLS  = *BLANKS
     C                   EVAL      S2PDES  = *BLANKS
     C                   EVAL      S2PCUR = *BLANKS
     C                   EVAL      S2POLS  = *BLANKS
     C                   EVAL      WSVPDES  = *BLANKS
     C                   EVAL      WSVPCUR = *BLANKS
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
     C                   WRITE     SD009563C2
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
     C                   IF        *IN92 = *ON
     C                   EVAL      WMAX = 10 - %REM(SRLRN2:10)
     C                   ELSE
     C                   Z-ADD     10            WMAX              5 0
     C                   ENDIF
     C                   DOW       WCTR4 <= WMAX

     C                   EVAL      S2NOST = *BLANKS
     C                   EVAL      S2NOSTH = *BLANKS
     C                   EVAL      S2ACNM = *BLANKS
     C                   EVAL      S2RPTN = *BLANKS
     C                   EVAL      S2RPTT = *BLANKS
     C                   EVAL      WCTR4  += 1
     C                   EVAL      SRLRN2 += 1

      *                                                                                     CGL176
     C                   IF        CGL176 = 'Y'                                             CGL176
     C                   EVAL      S2CMPY = *BLANKS                                         CGL176
     C                   ENDIF                                                              CGL176
      *                                                                                     CGL176
     C                   WRITE     SD009563S2
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

      ** Pool Validation
      ** ---------------

     C                   IF        CGL176 = 'Y'                                             CGL176
     C                   EVAL      *IN51   = *OFF                                           CGL176
     C                   ENDIF                                                              CGL176
     C                   EVAL      *IN41   = *OFF
     C                   EVAL      *IN44   = *OFF

     C                   IF        S2POLS  = *Blanks

     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'XXX9054'
     C                   EXSR      SRZasnms

     C                   ELSE

     C                   EVAL      WCNT = 0

     C                   EXSR      SRChkSDMNPHTD

     C                   IF        WCNT <> 0
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'XXX9063'
     C                   EXSR      SRZasnms
     C                   ELSE


     C                   IF        S2PCUR =  *BLANKS

     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN44 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0233'
     C                   EXSR      SRZasnms

     C                   ELSE
      ** Must be a valid currency

     C/exec sql
     C+ select * into :SDCURR from SDCURRPD
     C+ where A6CYCD = :S2PCUR
     C/end-exec

      ** Invalid currency

     C                   IF        SQLCOD <> 0
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN44 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'XXX9034'
     C                   EXSR      SRZasnms
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      *                                                                                     CGL176
     C                   IF        CGL176 = 'Y' AND                                         CGL176
     C                             SRLRN2 <> 1                                              CGL176
     C                   IF        S2CMPY <> S@CMPY AND                                     CGL176
     C                             S2CMPY <> *BLANKS AND                                    CGL176
     C                             S@CMPY <> *BLANKS                                        CGL176
     C                   EVAL      *IN40 = *ON                                              CGL176
     C                   EVAL      *IN51 = *ON                                              CGL176
     C                   EVAL      W#EROR = 'Y'                                             CGL176
     C                   EVAL      PZMsgID = 'XXX9065'                                      CGL176
     C                   EXSR      SRZasnms                                                 CGL176
     C                   ENDIF                                                              CGL176
     C                   ENDIF                                                              CGL176
      *                                                                                     CGL176
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

     C                   IF        CGL176 = 'Y'                                             CGL176
     C                   EVAL      *IN51 = *OFF                                             CGL176
     C                   ENDIF                                                              CGL176
     C                   EVAL      *IN44   = *OFF
     C                   EVAL      WNoDetail = 'Y'
     C                   EVAL      WCTR1  = 1
     C                   EVAL      WCTR2  = 0
     C                   EVAL      WANOST = *BLANKS
     C                   MOVE      *BLANKS       wErrYes           1
     C                   DOW       WCTR1 <= wSRLRN2

     C     WCTR1         CHAIN     SD009563S2

     C                   EVAL      *IN51 = *OFF
     C                   IF        %FOUND

     C                   IF        S2NOST <> *BLANKS
     C                   EVAL      WNoDetail = 'N'
     C                   ENDIF

     C                   IF        S2NOST <> *BLANKS

     C                   IF        S2NOST <> S2NOSTH

     C                   EXSR      SrChkNOSTRO

     C                   EXSR      SRChkSDMNPDTD

     C                   IF        WCNT <> 0

     C                   EVAL      *IN51  = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'XXX9062'
     C                   EXSR      SRZasnms

     C                   ELSE

     C                   IF        S2NOST <> *BLANKS

     C/EXEC SQL
     C+ Select COUNT(*) into: WCNT from SDMNPDTD
     C+ where P2NOST = :DSNOST and P2POOL = :S2POLS and P2RECI = 'D'
     C/END-EXEC

     C                   IF        %LOOKUP(S2NOST:WANOST) > 0 OR
     C                             WCNT > 0
     C                   EVAL      *IN51  = *ON
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'XXX9061'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      WCTR2 += 1
     C                   EVAL      WANOST(WCTR2) = S2NOST
     C                   SORTA     WANOST
     C                   ENDIF

     C                   ENDIF

      *                                                                                     CGL176
     C                   IF        CGL176 = 'Y'                                             CGL176
     C/exec sql                                                                             CGL176
     C+ select * into :SDBRCH from SDBRCHPD                                                 CGL176
     C+ where A8BRCD = :NBRCA                                                               CGL176
     C/end-exec                                                                             CGL176
     C                   IF        SQLCOD = 0                                               CGL176
     C                   EVAL      S#CMPY = A8CMCD                                          CGL176
     C                   IF        WCTR1 = 1                                                CGL176
     C                   EVAL      S@CMPY = A8CMCD                                          CGL176
     C                   ENDIF                                                              CGL176
     C                   ENDIF                                                              CGL176
      *                                                                                     CGL176
     C                   IF        S#CMPY <> S@CMPY AND                                     CGL176
     C                             S#CMPY <> *BLANKS AND                                    CGL176
     C                             S@CMPY <> *BLANKS                                        CGL176
     C                   EVAL      *IN40 = *ON                                              CGL176
     C                   EVAL      *IN51 = *ON                                              CGL176
     C                   EVAL      W#EROR = 'Y'                                             CGL176
     C                   EVAL      PZMsgID = 'XXX9065'                                      CGL176
     C                   EXSR      SRZasnms                                                 CGL176
     C                   ENDIF                                                              CGL176
     C                   ENDIF                                                              CGL176
      *                                                                                     CGL176
     C                   ENDIF

     C                   ELSE
      ** Write to Nostro array
     C                   EVAL      WCTR2 += 1
     C                   EVAL      WANOST(WCTR2) = S2NOST
     C                   SORTA     WANOST

     C                   ENDIF

     C                   IF        W#EROR2 = 'Y' AND wErrYes <> 'Y'
     C                   EVAL      wSRLRN2pc = SRLRN2
     C                   MOVE      'Y'           wErrYes
     C                   ENDIF

     C                   UPDATE    SD009563S2

     C                   ELSE

     C                   IF        S2ACNM <> *BLANKS OR
     C                             S2RPTN <> *BLANKS OR
     C                             S2RPTT <> *BLANKS
     C                   EVAL      S2ACNM = *BLANKS
     C                   EVAL      S2RPTN = *BLANKS
     C                   EVAL      S2RPTT = *BLANKS
      *                                                                                     CGL176
     C                   IF        CGL176 = 'Y'                                             CGL176
     C                   EVAL      S2CMPY = *BLANKS                                         CGL176
     C                   ENDIF                                                              CGL176
      *                                                                                     CGL176
     C                   UPDATE    SD009563S2
     C                   ENDIF

     C     WCTR1         CHAIN     SD009563S2
     C                   EVAL      SRLRN2 = wSRLRN2pc
     C                   UPDATE    SD009563S2

     C                   ENDIF

     C                   ENDIF

     C                   EVAL      WCTR1  += 1

     C                   ENDDO

     C                   IF        WNoDetail = 'Y'
     C                   EVAL      *IN51  = *ON
     C                   EVAL      WCTR1  = 1
     C                   DOW       WCTR1 <= 10
     C     WCTR1         CHAIN     SD009563S2
     C                   IF        %FOUND
     C                   UPDATE    SD009563S2
     C                   ENDIF
     C                   EVAL      WCTR1  += 1
     C                   ENDDO
     C     1             CHAIN     SD009563S2
     C                   IF        %FOUND
     C                   UPDATE    SD009563S2
     C                   ENDIF
     C                   EVAL      W#EROR2 = 'Y'
     C                   EVAL      PZMsgID = 'XXX9040'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
      * Check if Pivot Currency is in Nostro List
      *
     C                   Z-ADD     1             WTMP5X            5 0
     C                   Z-ADD     0             WCNT              5 0
     C     S2PCUR        CAT       '00'          WTMP5A            5
     C     S2PCUR        CAT       '99'          WTMP5Z            5
     C     S2PCUR        CAT       '%'           WTMP5T            4
      *
     C     WTMP5A        LOOKUP    WANOST(WTMP5X)                     99  96
     C     WTMP5Z        LOOKUP    WANOST(WTMP5X)                       9798
      *
     C                   IF        (*IN98 = *OFF and *IN96 = *OFF and
     C                             (*IN97 = *OFF or *IN99 = *OFF))
      *
     C                   Z-ADD     1             WTM5X             5 0
      *
     C     WTMP5A        LOOKUP    WASNOST(WTM5X)                       9798
     C                   IF        *IN97 = *ON
     C                   EVAL      WTM5X = WTM5X +1
     C                   ENDIF
     C                   DOW       WTM5X <= 1000 AND
     C                             %SUBST(WASNOST(WTM5X):1:3)=S2PCUR
     C                   EVAL      WCNT = WCNT +1
     C                   EVAL      WTM5X = WTM5X + 1
     C                   ENDDO
      *
     C                   Z-ADD     0             WTMP5X
      *
     C/exec sql
     C+ select count(*) into :WTMP5X from SDMNPDTD
     C+ where P2RECI = 'D' AND P2POOL = :S2POLS AND P2NOST LIKE :WTMP5T
     C/end-exec
      *
     C                   IF        (WTMP5X - WCNT) < 1
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN44 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'XXX9064'
     C                   EXSR      SRZasnms
     C                   ENDIF
      *
     C                   ENDIF
      *
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

     C                   IF        WQUEST = '?'                                             MD031323
     C                   EVAL      W1RSF = 'N'                                              MD031323
     C                   EVAL      WQUEST = *BLANKS                                         MD031323
     C                   ENDIF                                                              MD031323
                                                                                            MD031323
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkSDMNPHTD - Check if already exists in SDMNPHTD           *
      *                                                               *
      *****************************************************************

     C     SRChkSDMNPHTD BEGSR

     C                   IF        W1PMD = 'ADD'

     C/exec SQL
     C+ Select COUNT(*) into: WCNT from SDMNPHTD
     C+ where P1POOL = :S2POLS and P1RECI = 'D'
     C/end-exec

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkSDMNPDTD - Check if already exists in SDMNPDTD           *
      *                                                               *
      *****************************************************************

     C     SRChkSDMNPDTD BEGSR

     C                   EVAL      WSKIP = 'N'
     C                   IF        S1ACTN = 'A'
      ** Skip if nostro input already exists
     C                   IF        %LOOKUP(S2NOST:WASNOST) > 0
     C                   EVAL      WSKIP  = 'Y'
     C                   ENDIF

     C                   ENDIF

     C                   IF        WSKIP  = 'N'
     C/EXEC SQL
     C+ Select COUNT(*) into: WCNT from SDMNPDTD
     C+ where P2NOST = :DSNOST and P2POOL <>:S2POLS and P2RECI = 'D'
     C/END-EXEC
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInsSDMNPDTD - Insert Nostro Details                         *
      *                                                               *
      *****************************************************************

     C     SRInsSDMNPDTD BEGSR

     C                   EVAL      WCTR1 = 1
     C                   DOW       WCTR1 <= wSRLRN2

     C     WCTR1         CHAIN     SD009563S2

     C                   IF        %FOUND

     C                   IF        S2NOST <> *BLANKS

     C/EXEC SQL
     C+ Insert Into SDMNPDTD
     C+ (
     C+   P2RECI
     C+ , P2POOL
     C+ , P2NOST
     C+ , P2DATE
     C+ , P2TMST
     C+ , P2ACTN
     C+ , P2USER
     C+ )
     C+ Values
     C+ (
     C+   'D'
     C+ , :S2POLS
     C+ , :DSNOST
     C+ , :BJRDNB
     C+ , :WTIME
     C+ , 'I'
     C+ , :PSUser
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
      * SRUpdSDMNPDTD - Amend Nostro Details                          *
      *                                                               *
      *****************************************************************

     C     SRUpdSDMNPDTD BEGSR

     C                   EVAL      WUPDFLG = 'N'
     C                   EVAL      WCTR1 = 1
     C                   DOW       WCTR1 <= wSRLRN2

     C     WCTR1         CHAIN     SD009563S2

     C                   IF        %FOUND

     C                   IF        S2NOST <> *BLANKS

     C                   IF        S2NOST <> S2NOSTH

     C                   IF        S2NOSTH <> *BLANKS

     C/EXEC SQL
     C+ Update SDMNPDTD set P2NOST = :DSNOST,
     C+ P2DATE = :BJRDNB, P2USER = :PSuser, P2ACTN = 'A',
     C+ P2TMST = :WTIME
     C+ where P2POOL = :S1POOL  and P2NOST = :DSNOSTH
     C/END-EXEC
     C                   EVAL      WUPDFLG = 'Y'

     C                   ELSE

     C/EXEC SQL
     C+ Insert Into SDMNPDTD
     C+ (
     C+   P2RECI
     C+ , P2POOL
     C+ , P2NOST
     C+ , P2DATE
     C+ , P2TMST
     C+ , P2ACTN
     C+ , P2USER
     C+ )
     C+ Values
     C+ (
     C+   'D'
     C+ , :S2POLS
     C+ , :DSNOST
     C+ , :BJRDNB
     C+ , :WTIME
     C+ , 'I'
     C+ , :PSUser
     C+ )
     C/END-EXEC
     C                   EVAL      WUPDFLG = 'Y'
     C                   ENDIF

     C                   ENDIF

     C                   ELSE

     C                   IF        S2NOSTH <> *BLANKS

     C/EXEC SQL
     C+ Update SDMNPDTD set P2RECI = '*',
     C+ P2USER = :PSuser, P2ACTN = 'D', P2TMST = :WTIME
     C+ where P2POOL = :S1POOL  and P2NOST = :DSNOSTH
     C/END-EXEC
     ***
     ***C+ Delete FROM SDMNPDTD
     ***C+ where P2POOL = :S1POOL  and P2NOST = :DSNOSTH
     ***
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
      * SRDelSDMNPDTD - Delete Nostro Details                         *
      *                                                               *
      *****************************************************************

     C     SRDelSDMNPDTD BEGSR

     C/EXEC SQL
     C+ Update SDMNPDTD set P2RECI = '*',
     C+ P2USER = :PSuser, P2ACTN = 'D', P2TMST = :WTIME
     C+ where P2POOL = :S1POOL  and P2RECI = 'D'
     C/END-EXEC

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInsSDMNPHTD - Insert Pool header                            *
      *                                                               *
      *****************************************************************

     C     SRInsSDMNPHTD BEGSR

     C/EXEC SQL
     C+ Insert Into SDMNPHTD
     C+ (
     C+   P1RECI
     C+ , P1POOL
     C+ , P1PDSC
     C+ , P1PCCY
     C+ , P1DATE
     C+ , P1TMST
     C+ , P1ACTN
     C+ , P1USER
     C+ , P1CNTR
     C+ )
     C+ Values
     C+ (
     C+   'D'
     C+ , :S2POLS
     C+ , :S2PDES
     C+ , :S2PCUR
     C+ , :BJRDNB
     C+ , :WTIME
     C+ , 'I'
     C+ , :PSUser
     C+ , 0
     C+ )
     C/END-EXEC

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdSDMNPHTD - Update Pool header                            *
      *                                                               *
      *****************************************************************

     C     SRUpdSDMNPHTD BEGSR

     C                   IF        WUPDFLG = 'Y' OR
     C                             (S2PDES  <> WSVPDES  OR
     C                              S2PCUR  <> WSVPCUR)

     C/EXEC SQL
     C+ UPDATE SDMNPHTD SET P1PDSC = :S2PDES , P1PCCY = :S2PCUR,
     C+ P1TMST = :WTIME,
     C+ P1ACTN = 'A', P1USER = :PSuser
     C+ where P1POOL = :S1POOL
     C/END-EXEC

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelSDMNPHTD - Delete Pool header                            *
      *                                                               *
      *****************************************************************

     C     SRDelSDMNPHTD BEGSR

     C/EXEC SQL
     C+ UPDATE SDMNPHTD SET P1RECI = '*',
     C+ P1USER = :PSuser, P1ACTN = 'D', P1TMST = :WTIME
     C+ where P1POOL = :S1POOL
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

      ** Delete MNCP pool

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
     C                   EVAL      S1POLS = *Blanks
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

      ** Amend MNCP pool

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
     C                   EVAL      S1POOL  = *BLANKS
     C                   EVAL      S1PDES  = *BLANKS
     C                   EVAL      S1PCUR  = *BLANKS

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
      *                                                                                     CGL176
     C                   IF        CGL176 = 'Y'                                             CGL176
     C                   EVAL      S2CMPY = *BLANKS                                         CGL176
     C                   ENDIF                                                              CGL176

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMoveSfl1 - Transfer Records from SDMNPHTD to Subfile        *
      *                                                               *
      *****************************************************************

     C     SRMoveSfl1    BEGSR

      ** Move SDMNPHTD fields to subfile

     C                   EVAL      S1POOL  = A_P1POOL
     C                   EVAL      S1PDES  = A_P1PDSC
     C                   EVAL      S1PCUR = A_P1PCCY

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMoveSfl2 - Transfer Records from SDMNPDTD to Subfile        *
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

      *                                                                                     CGL176
     C                   IF        CGL176 = 'Y'                                             CGL176
     C/exec sql
     C+ select * into :SDBRCH from SDBRCHPD
     C+ where A8BRCD = :NBRCA
     C/end-exec
     C                   IF        SQLCOD = 0                                               CGL176
     C                   EVAL      S2CMPY = A8CMCD                                          CGL176
     C                   IF        SRLRN2 = 1                                               CGL176
     C                   EVAL      S@CMPY = A8CMCD                                          CGL176
     C                   ENDIF                                                              CGL176
     C                   ENDIF                                                              CGL176
     C                   ENDIF                                                              CGL176
      *                                                                                     CGL176
     C                   IF        S1ACTN = 'A'
     C                   EVAL      WCTR3 += 1
     C                   EVAL      WASNOST(WCTR3) = B_P2NOST
     C                   SORTA     WASNOST
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

     C                   MOVEL     S2NOST        W2NOST            5
     C                   MOVEL     S2NOST        WQUEST            1
     C                   IF        WQUEST = '?'

     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      *BLANKS       PCUST
     C                   PARM                    DSNCCY
     C                   PARM      *BLANKS       PACCN
     C                   PARM      *BLANKS       PACSN
     C                   PARM                    DSNOSC
     C                   PARM      *BLANKS       PBRCD
     C                   PARM      *BLANKS       PCSSN
     C                   PARM      *BLANKS       PPNOI
     C     SDNOST        PARM      *BLANKS       DSFDY

     C                   ENDIF
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

      *                                                                                     CGL176
     C                   IF        CGL176 = 'Y'                                             CGL176
     C/exec sql
     C+ select * into :SDBRCH from SDBRCHPD
     C+ where A8BRCD = :NBRCA
     C/end-exec
     C                   IF        SQLCOD = 0                                               CGL176
     C                   EVAL      S2CMPY = A8CMCD                                          CGL176
     C                   IF        SRLRN2 = 1                                               CGL176
     C                   EVAL      S@CMPY = A8CMCD                                          CGL176
     C                   ENDIF                                                              CGL176
     C                   ENDIF                                                              CGL176
     C                   ENDIF                                                              CGL176
      *                                                                                     CGL176

     C                   ELSE

     C                   MOVEL     W2NOST        S2NOST
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
      * SRDelete - Delete Nostro Header                               *
      *                                                               *
      *****************************************************************

     C     SRDelete      BEGSR

     C                   EXSR      SRInitHdr2

     C                   EXSR      SRInitSfl2

     C/EXEC SQL
     C+    SELECT *
     C+ into :MNCPGDDS
     C+ from SDMNPDTD
     C+ where P2POOL = :S1POOL  AND P2RECI = 'D'
     C/END-EXEC

      ** Record already deleted

     C                   If        %Subst(SQLState:1:2) = '02'
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7602'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      S2MODE = 'DELETE'

     C                   EVAL      S2POLS  = S1POOL
     C                   EVAL      S2PDES  = S1PDES
     C                   EVAL      S2PCUR = S1PCUR

      ** Reset field error indicators.

     C                   EVAL      *IN36 = *OFF
     C                   EVAL      *IN37 = *OFF
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN39 = *ON

     C                   EXSR      SRBldSfl2

     C                   EVAL      W1RSF = 'N'

     C                   DOW       *IN03 = *OFF and
     C                             *IN12 = *OFF and
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

     C                   IF        *IN10 = *ON

     C                   EVAL      WTIME = %TIMESTAMP
     C                   EXSR      SRDelSDMNPDTD
     C                   EXSR      SRDelSDMNPHTD

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAddReq - Update Nostro Header                               *
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
     C                             *IN12 = *OFF and
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
      * SRAmend  - Update Nostro Header                               *
      *                                                               *
      *****************************************************************

     C     SRAmend       BEGSR

     C                   EXSR      SRInitHdr2


      ** Initialise & load blank subfile page

     C                   EXSR      SRInitSfl2

     C/EXEC SQL
     C+ SELECT *
     C+ into :MNCPGDDS
     C+ from SDMNPDTD
     C+ where P2POOL = :S1POOL  AND P2RECI = 'D'
     C/END-EXEC

      ** Record not found

     C                   If        %Subst(SQLState:1:2) = '02'

     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7605'
     C                   EXSR      SRZasnms
     C                   ELSE

      ** Move to display file fields

     C                   EVAL      S2MODE = 'AMEND  '
     C                   EVAL      S2POLS  = S1POOL
     C                   EVAL      S2PDES  = S1PDES
     C                   EVAL      S2PCUR = S1PCUR
     C                   EVAL      WSVPDES  = S1PDES
     C                   EVAL      WSVPCUR = S1PCUR
     C                   EVAL      WUPDFLG = 'N'

      ** Reset field error indicators.

     C                   EVAL      *IN36 = *OFF
     C                   EVAL      *IN37 = *ON
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN39 = *OFF

     C                   EXSR      SRBldSfl2
      ** Add new lines
     C                   IF        *IN92 = *ON
     C                   EXSR      SRLoadInpScr
     C                   ENDIF
      ** Position cursor
     C                   EVAL      SRLRN2 = 1
     C     SRLRN2        CHAIN     SD009563S2
     C                   IF        %FOUND
     C                   UPDATE    SD009563S2
     C                   ENDIF
      ** Rolldown
     C                   EVAL      *IN92  = *OFF

     C                   ENDIF

     C                   EVAL      W1RSF = 'N'
     C                   DOW       *IN03 = *OFF and
     C                             *IN12 = *OFF and
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
      * SRUpdatCtr - Update Counter field of SDMNPHTD Header file     *
      *                                                               *
      *****************************************************************

     C     SRUpdatCtr    BEGSR

      ** Get record count of SDMNPDTD with Pool equal to Pool entered

     C/exec SQL
     C+ SELECT COUNT(*) into: DetailCtr from SDMNPDTD
     C+                       where P2POOL = :PoolWrkFld
     C+                       and P2RECI = 'D'
     C/End-Exec

      ** Update COUNTER field of SDMNPHTD with DetailCtr

     C/exec SQL
     C+ UPDATE SDMNPHTD set P1CNTR = :DetailCtr
     C+                       where P1POOL = :PoolWrkFld
     C/End-Exec

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

     C                   IF        WCTR1 = 1 AND *IN51 = *ON
     C                   EVAL      *IN52 = *ON
     C                   ENDIF

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
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

      ** Receive entry parameters

     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    PMODE

      ** Define LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SD009563'
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
     C                   EVAL      DBPGM  = 'SD009563'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Open files for update

     C                   OPEN      SD009563DF

     C/exec sql
     C+ declare MNCPGH   Scroll Cursor
     C+  for select *
     C+  from SDMNPHTD
     C+  where P1RECI = 'D' and P1POOL >= :S1POLS
     C+  order by
     C+  P1POOL
     C/end-exec

     C/exec sql
     C+ open MNCPGH
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

     C                   EVAL      S1POLS = *BLANKS

      ** Check if CGL176 feature is enabled                                                 CGL176
     C                   EVAL      CGL176 = 'N'                                             CGL176
      *enable Non-display indicator                                                         CGL176
     C                   EVAL      *IN15 = *ON                                              CGL176
     C                   CALL      'AOSARDR0'                                               CGL176
     C                   PARM      *BLANKS       PRTCD                                      CGL176
     C                   PARM      '*VERIFY'     POPTN                                      CGL176
     C                   PARM      'CGL176'      PSARD                                      CGL176
     C     SCSARD        PARM      SCSARD        DSFDY                                      CGL176
      *                                                                                     CGL176
     C                   IF        PRTCD = *BLANKS                                          CGL176
     C                   EVAL      CGL176 = 'Y'                                             CGL176
      *disable Non-display indicator                                                        CGL176
     C                   EVAL      *IN15 = *OFF                                             CGL176
     C                   ENDIF                                                              CGL176
      *
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ACTCHECK - Action Code Authorization Check                   *
      *                                                               *
      *****************************************************************

     C     ACTCHECK      BEGSR

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
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

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

