     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2018')
      *****************************************************************
/*STD *  RPGSQLMOD                                                    *
/*EXI *  TEXT('Midas SD Customer Ranges Definition')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000951 - Customer Ranges Definition Maintenance            *
      *                                                               *
      *  Function: This program maintains the Customer Ranges Def.    *
      *                                                               *
      *  (c) Finastra International Limited 2018                      *
      *                                                               *
      *  Last Amend No. CRE113  *CREATE    Date 05Feb18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE113 - COB Optimisation of REC376A                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03         F3 Exit                                         *
      *    05         F5 Refresh                                      *
      *    09         F9 Add/Change Mode                              *
      *    10         F10 Delete                                      *
      *    12         F12 Cancel/Previous screen                      *
      *    27         Rollup/Rolldown Key                             *
      *    31         Maintenance/Enquiry Mode                        *
      *    32         Invalid Selection                               *
      *    40         Global Error Indicator                          *
      *    41         First Customer in Range Indicator               *
      *    42         Last Customer in Range Indicator                *
      *    60         READ/READP/CHAIN Indicator                      *
      *    61         WRITE Indicator                                 *
      *    62         READC Indicator                                 *
      *    80         Subfile Clear (SFLCLR)                          *
      *    81         Subfile Display (SFLDSP)                        *
      *    82         Subfile End (SFLEND)                            *
      *    83         Force Input Format                              *
      *    84         Subfile Next Change (SFLNXTCHG)                 *
      *    86         PUTOVR Indicator                                *
      *    87         Enable Key Screen                               *
      *    89         Add Mode                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR        -  Program Initialisation Routine              *
      *  SRBuild       -  Initialise and load subfile page            *
      *  SRLoad        -  Load subfile page                           *
      *  SRDisplay     -  Display subfile                             *
      *  SRProcess     -  Process screen input                        *
      *  SRUpdate      -  Update records from subfile                 *
      *  SRDetail      -  Process action requested                    *
      *  SRAddReq      -  Process add request                         *
      *  SRDelReq      -  Process delete request                      *
      *  SRAmdReq      -  Process amend request                       *
      *  SRMode        -  Switch between *ADD and *CHANGE modes       *
      *  SRReload      -  Request subfile reload                      *
      *  SRClrScrn     -  Initialise subfile record                   *
      *  SRMove        -  Transfer records from SDCUSRTD to subfile   *
      *  SRWrite       -  Create Customer Range Details               *
      *  SRValInput    -  Validate Customer Input                     *
      *  SRDelete      -  Delete Customer Range Details               *
      *  SRAmend       -  Update Customer Range Details               *
      *  SRZasnms      -  Message handling subroutine                 *
      *  SREnd         -  End program                                 *
      *  *PSSR         -  Error handling subroutine                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Customer Ranges Definition Display File
     FSD000951DFCF   E             WORKSTN USROPN
     F                                     SFILE(SD000951S1:SRLRN)
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
      **------------------------------------------------------------------------
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

      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      **  External DS for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)


     D CusRangeDS    E DS                  EXTNAME(SDCUSRTD)


     D pSQL_RanOk      PR              N
     D  iSQLState                     5A   Const


      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+


     D @RUN            S              1
     D CAIN89          S              1
     D CPY2@           S             80

      ** Database error workfields
     D PRTCD           S              7
     D POPTN           S              7

      ** Message file workfields - Parameters list for ZA0340 / ZA0350
     D PZMsgFile       S             10A   INZ('GBSDUSRMSG')
     D PZMsgID         S             10
     D PZMsgDta        S             45A

      ** General workfields
     D CAIN81          S              1
     D PMODE           S              1
     D WKIPIN          S              1
     D WCUST           S              1
     D WLRCD           S              4  0
     D WPOSN           S              5
     D WRCTR           S              5  0
     D WSFPG           S              3  0
     D W1PMD           S              3
     D W1RSF           S              1
     D W2RSF           S              1
     D W#EROR          S              1
     D W#EROR2         S              1
     D CountRange      S              2  0

      ** Subfile workfields
     D WSkipRec        S              1
     D W0RTN           S              7


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

     C                   EXSR      SRBuild

     C                   EVAL      W1RSF = 'N'

      ** Display screen until reload requested

     C                   DOW       W1RSF = 'N'

      ** Display screen

     C                   EXSR      SRDisplay

      ** Process response

     C     *IN03         CASEQ     *ON           SREnd

     C     *IN05         CASEQ     *ON           SRReload

     C     *IN27         CASEQ     *ON           SRLoad

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
      * SRBuild - Initialise and Load Subfile Page                    *
      *                                                               *
      *****************************************************************
     C     SRBuild       BEGSR

      ** Initialise & load subfile page

     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD000951C1
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      *IN79 = *OFF

      ** Reset Number of Records in Subfile

     C                   Z-ADD     0             WLRCD

      ** If CHANGE mode, then position file

     C                   EVAL      *IN82 = *OFF

     C                   IF        W1PMD <> 'ADD'
     C                   EVAL      WPOSN = SPOSN

      ** Setup key

     C/exec SQL
     C+ close CustRangeFile
     C/end-exec

     C/exec sql
     C+ open CustRangeFile
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CustRangeFile
     C+ into :CusRangeDS
     C/end-exec

     C                   ELSE
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF

     C                   If        %Subst(SQLState:1:2) = '02'
     C                   EVAL      *IN82 = *ON
     C                   ENDIF

      ** Save previous selector values

     C     *LIKE         DEFINE    #1POS1        WFCIR
     C                   EVAL      WFCIR = #1POS1
     C     *LIKE         DEFINE    #1POS2        WLCIR
     C                   EVAL      WLCIR = #1POS2


      ** Load subfile page

     C                   EXSR      SRLoad

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
      * SRLoad - Load Subfile Page                                    *
      *                                                               *
      *****************************************************************
     C     SRLoad        BEGSR

      ** Load subfile page but write empty page if add mode

     C                   EVAL      *IN84 = *OFF

      ** Re-establish fields in read-ahead record

     C                   IF        W1PMD <> 'ADD' and *IN27 = *ON
     C                   If        pSQL_RanOk(SQLSTATE)

     C/exec SQL
     C+ fetch prior
     C+ from CustRangeFile
     C+ into :CusRangeDS
     C/end-exec

     C/exec SQL
     C+ fetch next
     C+ from CustRangeFile
     C+ into :CusRangeDS
     C/end-exec

     C                   ENDIF
     C                   ENDIF

      ** Start at previous highest record in SFL

     C                   Z-ADD     WLRCD         SRLRN
     C                   Z-ADD     1             WRCTR

      ** Load next subfile page

     C                   DOW       %Subst(SQLState:1:2) <> '02'
     C                             and WRCTR <= WSFPG

     C                   EVAL      WSkipRec = 'N'
     C                   ADD       1             SRLRN
     C                   EVAL      *IN32 = *OFF

      ** Protect fields during Enquiry Mode

     C                   IF        (W1PMD <> 'ADD')
     C                   SELECT

     C                   WHEN      #1POS1 <> *BLANK  AND  CRFCIR <> #1POS1
     C                   EVAL      WSkipRec = 'Y'

     C                   WHEN      #1POS2 <> *BLANK AND CRLCIR <> #1POS2
     C                   EVAL      WSkipRec = 'Y'

     C                   ENDSL
     C                   ENDIF

     C                   IF        WSkipRec = 'N'

      ** Clear subfile fields

     C                   EXSR      SRClrScrn

      ** If CHANGE mode, load subfile fields

     C                   IF        W1PMD <> 'ADD'
     C                   EXSR      SRMove

     C                   ENDIF

      ** Output to subfile

     C                   ADD       1             WRCTR                81
     C                   EVAL      *IN81 = *ON

      ** If SFLRCD invalid, note that errors present

     C                   IF        *IN83 = *ON and *IN40 = '0'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF

     C                   WRITE     SD000951S1

     C                   ELSE
     C                   SUB       1             SRLRN
     C                   ENDIF

     C*                  ENDIF

      ** End of File

     C                   IF        W1PMD <> 'ADD'

     C/exec SQL
     C+ fetch next
     C+ from CustRangeFile
     C+ into :CusRangeDS
     C/end-exec

     C                   IF        %Subst(SQLState:1:2) = '02'
     C                   EVAL      *IN82 = *ON
     C                   ELSE
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF

     C                   ENDIF

     C                   ENDDO

     C                   Z-ADD     SRLRN         WLRCD

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display Subfile                                  *
      *                                                               *
      *****************************************************************

     C     SRDisplay     BEGSR

      ** Set screen conditioning indicators

     C                   IF        W1PMD = 'ADD'
     C                   EVAL      *IN89 = *ON
     C                   ELSE
     C                   EVAL      *IN89 = *OFF
     C                   ENDIF

      ** PUTOVR unless conditioned fields change

     C                   IF        *IN89 <> CAIN89 OR *IN81 <> CAIN81
     C                   EVAL      *IN86 = *OFF
     C                   ENDIF

     C                   EVAL      CAIN89 = *IN89
     C                   EVAL      CAIN81 = *IN81

      ** Display appropriate Header depending upon Mode whether it is
      ** Enquiry or Maintenance

     C                   IF        PMODE = 'E'
     C                   EVAL      *IN31 = *ON
     C                   ENDIF

      ** Display appropriate Header depending upon Mode whether it is
      ** Enquiry or Maintenance

      ** Set cursor by *SET CURSOR data

     C                   TIME                    #1TIME
     C                   WRITE     SD000951C2
     C                   WRITE     SD000951F1
     C                   EXFMT     SD000951C1

      ** Clear messages from program message queue

     C                   CALL      'ZA0250'

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
     C                             OR WFCIR <> #1POS1 OR WLCIR <> #1POS2
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


      ** Switch between *ADD/*CHANGE modes is allowed when no errors
      ** exists during update

     C                   IF        *IN09 = *ON and *IN40 = *OFF
     C                   EXSR      SRMode
     C                   ENDIF

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

      ** Initialise subfile reload flag

     C                   IF        W1PMD = 'ADD'
     C                   EVAL      W1RSF = 'Y'
     C                   ELSE
     C                   EVAL      W1RSF = 'N'
     C                   ENDIF

     C                   EXSR      SRDetail

      ** Cancel reload if errors occur

     C                   IF        *IN40 = *ON
     C                   EVAL      W1RSF = 'N'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetail - Process action requested                           *
      *                                                               *
      *****************************************************************
     C     SRDetail      BEGSR

      ** Set off error indicators

     C                   EVAL      *IN32 = *OFF
     C                   EVAL      *IN83 = *OFF

     C                   EXSR      SRWrite
     C                   IF        *IN83 = *ON and *IN40 = *OFF
     C                   EVAL      *IN40 = *ON
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

      ** Create Customer Range Data Details

     C                   EVAL      #1FCIR = *BLANKS
     C                   EVAL      #1LCIR = *BLANKS
     C                   EVAL      *IN71 = *OFF
     C                   EVAL      *IN73 = *OFF
     C                   EVAL      *IN70 = *ON
     C                   EVAL      *IN89 = *ON
     C                   MOVE      *BLANKS       W#ACT             1

      ** Process Amend/Delete Request

     C                   IF        W1PMD = 'CHG' and *IN09 <> *ON

     C                   DOW       *IN03 = *OFF and *IN12 = *OFF
     C                             and W1RSF = 'N' and WLRCD <> *ZEROS

      ** Check if Enquire

     C                   READC     SD000951S1                             62

     C                   DOW       *IN62 = *OFF

      ** Invalid Action Code

     C                   IF        (#1ACTN <> 'E' and #1ACTN <> 'D' and
     C                             #1ACTN <> 'A') or (#1ACTN <> 'E' and
     C                             PMODE = 'E'  )
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      PZMsgID = 'CSF9853'

     C                   IF        PMODE = 'E'
     C                   EVAL      PZMsgID = 'CSF9854'
     C                   ENDIF

     C                   EXSR      SRZasnms
     C                   EVAL      *IN40 = *ON
     C                   LEAVE

     C                   ELSE

     C                   IF        #1ACTN <> ' '

     C                   EVAL      W#ACT = #1ACTN
     C                   IF        #1ACTN = 'E'
     C                   EXSR      SREnqReq
     C                   ENDIF

      ** Check if Delete
     C                   IF        #1ACTN = 'D' and PMODE = 'M'
     C                   EXSR      SRDelReq
     C                   ENDIF

      ** Check if Amend
     C                   IF        #1ACTN = 'A' and PMODE = 'M'
     C                   EXSR      SRAmdReq
     C                   ENDIF

     C                   ENDIF

     C                   IF        *IN12 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   LEAVE
     C                   ENDIF

     C                   READC     SD000951S1                             62
     C                   IF        *IN62 = *OFF
     C                   EVAL      W1RSF = 'N'
     C                   ENDIF

     C                   ENDIF

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

     C                   EXSR      SRCount

      ** Maximum customer range to be entered is 40

     C                   IF        CountRange < 40
      ** Process Add Request

     C                   EVAL      W#ACT = 'I'
     C                   EXSR      SRAddReq

      ** Update Database

     C                   IF        (W#EROR =*BLANKS) AND (WKIPIN = 'Y')
     C                             and *IN12 = *OFF and *IN03 = *OFF
     C                   EXSR      SRUpdate
     C                   ENDIF

     C                   IF        W#EROR = *BLANKS and *IN12 = *OFF
     C                                              and *IN03 = *OFF
     C                   EVAL      W1PMD = 'ADD'
     C                   EXSR      SRReload
     C                   EVAL      *IN12 = *ON
     C                   ENDIF

     C                   ELSE
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR8501'
     C                   EXSR      SRZasnms
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      *IN43 = *OFF
     C                   EVAL      *IN44 = *OFF
     C                   EVAL      *IN84 = *OFF
     C                   EVAL      *IN89 = *OFF
     C                   EVAL      *IN31 = *OFF
     C                   EVAL      *IN37 = *OFF
     C                   EVAL      *IN38 = *OFF
     C                   EVAL      *IN39 = *OFF

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
     C+ into :CusRangeDS
     C+ from SDCUSRTD
     C+ where CRFCIR = :#1FCIR and
     C+       CRLCIR = :#1LCIR
     C/END-EXEC

     C                   If        %Subst(SQLState:1:2) = '02'

      ** Error message if record is missing

     C                   EVAL      *IN40 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7517'
     C                   EXSR      SRZasnms
     C                   ELSE

     C                   EXSR      SRScrn2Clr


     C                   EVAL      #2MODE = 'ENQUIRY'
     C                   EVAL      #2FCIR = #1FCIR
     C                   EVAL      #2LCIR = #1LCIR

     C                   EVAL      W2RSF = 'N'

      ** Reset field error indicators.

     C                   EVAL      *IN45 = *OFF
     C                   EVAL      *IN47 = *OFF
     C                   EVAL      *IN75 = *OFF

     C                   IF        PMODE = 'E' OR W#ACT = 'E'
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN31 = *ON
     C                   ENDIF

     C                   DOW       *IN03 = *OFF and *IN12 = *OFF and
     C                             W2RSF = 'N'
     C                   WRITE     SD000951C2
     C                   WRITE     SD000951F1
     C                   EXFMT     SD000951D2
     C                   IF        *IN03 = *OFF and *IN12 = *OFF
     C                   EVAL      W2RSF = 'Y'
     C                   ENDIF
     C                   ENDDO

     C                   ENDIF
     C                   EVAL      W1RSF = 'N'
     C                   IF        PMODE = 'E'  OR W#ACT = 'E'
     C                   EVAL      *IN38 = *OFF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScrn2 - Process Second Input Screen                         *
      *                                                               *
      *****************************************************************
     C     SRScrn2       BEGSR

      ** Error detected

     C                   EVAL      *IN45 = *OFF
     C                   EVAL      *IN46 = *OFF
     C                   EVAL      *IN47 = *OFF
     C                   IF        W#ACT = 'D'
     C                   EVAL      *IN55 = *OFF
     C                   ELSE
     C                   EVAL      *IN55 = *ON
     C                   ENDIF

     C                   IF        *IN09 = *ON
     C                   EXSR      SRScrn2Clr
     C                   EVAL      #2MODE = 'INSERT  '
     C                   EVAL      #2FCIR = #1FCUS
     C                   EVAL      #2LCIR = #1LCUS
     C                   ENDIF

     C                   SELECT
     C                   WHEN      W#ACT = 'A'
     C                   EVAL      #2MODE = 'AMEND   '
     C                   EVAL      #2FCIR = #1FCUS
     C                   EVAL      #2LCIR = #1LCUS
     C                   EVAL      *IN37 = *OFF
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN75 = *ON
     C                   WHEN      W#ACT = 'E'
     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN75 = *OFF
     C                   WHEN      W#ACT = 'D'
     C                   EVAL      *IN75 = *OFF
     C                   EVAL      *IN39 = *ON
     C                   ENDSL

     C                   DOW       *IN03 = *OFF and *IN12 = *OFF and
     C                             W1RSF = 'N'
     C                   WRITE     SD000951C2
     C                   WRITE     SD000951F1
     C                   EXFMT     SD000951D2

      ** Clear messages from program message queue

     C                   CALL      'ZA0250'
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   EVAL      *IN42 = *OFF
     C                   EVAL      W#EROR2 = 'N'

      ** Reset field error indicators.

     C                   EVAL      *IN45 = *OFF
     C                   EVAL      *IN46 = *OFF
     C                   EVAL      *IN47 = *OFF

     C                   IF        *IN03 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      W1PMD = 'CHG'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
     C                   IF        W#EROR2 = 'N' and *IN05 = *OFF and
     C                             *IN12 = *OFF and *IN03 = *OFF
     C                   EVAL      W1PMD = 'CHG'
     C                   IF        W#ACT = 'D' AND *IN10 = *OFF
     C                   EVAL      W1RSF = 'N'
     C                   ELSE
     C                   EVAL      W1RSF = 'Y'
     C                   ENDIF
     C                   EVAL      WKIPIN = 'Y'
     C                   ENDIF

     C                   ENDDO

     C                   SELECT
     C                   WHEN      (*IN09 = *ON AND *IN12 = *OFF)
     C                             OR W#ACT = 'A'
     C                   EVAL      *IN37 = *OFF
     C                   WHEN      W#ACT = 'E'
     C                   EVAL      *IN38 = *OFF
     C                   WHEN      W#ACT = 'D'
     C                   EVAL      *IN39 = *OFF
     C                   ENDSL

     C                   IF        *IN12 = *ON
     C                   IF        PMODE = 'M' AND W#ACT = 'I'
     C                   EVAL      *IN12 = *OFF
     C                   EVAL      W1RSF = 'N'
     C                   ELSE
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      W1PMD = 'CHG'
     C                   EVAL      #1FCIR = *BLANKS
     C                   EVAL      #1LCIR = *BLANKS
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      *IN55 = *OFF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScrn2Clr - Clear fields for input in Second screen          *
      *                                                               *
      *****************************************************************
     C     SRScrn2Clr    BEGSR

     C                   EVAL      #2FCIR = *BLANKS
     C                   EVAL      #2LCIR = *BLANKS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAddReq - Process Add Request                                *
      *                                                               *
      *****************************************************************
     C     SRAddReq      BEGSR

     C                   EVAL      #1MODE = 'INSERT '
     C                   EVAL      #1FCUS = *BLANKS
     C                   EVAL      #1LCUS = *BLANKS

     C                   EVAL      *IN38 = *ON
     C                   EVAL      *IN75 = *ON

     C                   EXSR      SRValInput

     C                   EVAL      *IN37 = *OFF

      ** Clear messages from program message queue

     C                   CALL      'ZA0250'

     C                   IF        *IN03 = *ON or *IN12 = *ON
     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      W1PMD = 'ADD'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelReq - Process Delete Request                             *
      *                                                               *
      *****************************************************************
     C     SRDelReq      BEGSR

      ** Delete Customer Ranges Data Details

     C                   EXSR      SRDelete

     C                   IF        W#EROR <> *BLANKS

      ** Delete unsuccessful

     C                   EVAL      *IN32 = *ON
     C                   MOVEA     '11'          *IN(83)
     C                   EXSR      SRMove
     C                   ELSE

      ** Blank out record and protect from entry

     C                   EXSR      SRClrScrn
     C                   EVAL      *IN84 = *OFF

      ** Reload subfile

     C                   EVAL      W1RSF = 'Y'
     C                   EVAL      #1POS1 = *Blanks
     C                   EVAL      #1POS2 = *Blanks
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAmdReq - Process Amend Request                              *
      *                                                               *
      *****************************************************************

     C     SRAmdReq      BEGSR

      ** Amend Customer Ranges Data Details

     C                   EXSR      SRAmend

     C                   IF        W#EROR <> *BLANKS or *IN03 = *ON or
     C                             *IN12 = *ON
     C                   EVAL      *IN32 = *ON
     C                   MOVEA     '11'          *IN(83)

      ** Reset subfile record if changed record

     C                   EXSR      SRMove
     C                   ELSE
     C                   EVAL      *IN84 = *OFF
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

     C                   IF        *IN05 = *ON
     C                   EVAL      SPOSN = *BLANKS
     C                   EVAL      #1ACTN = *BLANKS
     C                   EVAL      #1POS1 = *Blanks
     C                   EVAL      #1POS2 = *Blanks
     C                   ENDIF

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

     C                   EVAL      #1ACTN = *BLANKS
     C                   EVAL      #1FCIR = *BLANKS
     C                   EVAL      #1LCIR = *BLANKS
     C                   EVAL      #1OR = *BLANKS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMove - Transfer Records from SDCUSRTD to Subfile            *
      *                                                               *
      *****************************************************************
     C     SRMove        BEGSR

      ** Move SDCUSRTD fields to subfile

     C                   EVAL      #1FCIR = CRFCIR
     C                   EVAL      #1LCIR = CRLCIR
     C                   IF        SRLRN > 1
     C                   EVAL      #1OR = 'OR'
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      *                                                               *
      * SRValInput - Validate Customer Ranges Input                   *
      *                                                               *
      *****************************************************************
     C     SRValInput    BEGSR
     C
     C                   DOW       *IN03 = *OFF and *IN12 = *OFF
     C                             and W1RSF = 'N'
     C                   WRITE     SD000951C2
     C                   WRITE     SD000951F1
     C                   EXFMT     SD000951D1

      ** Clear messages from program message queue
      ** and reset work fields

     C                   CALL      'ZA0250'
     C                   EVAL      W#EROR = *BLANKS
     C                   MOVEA     '00000'       *IN(40)

      ** If Exit not pressed, validate Input Screen 1 fields first
      ** before displaying the second Input screen

     C                   IF        *IN03 = *OFF and *IN12 = *OFF

     C                   IF        *IN05 = *ON

     C                   IF        *IN09 = *ON
     C                   EVAL      #1FCUS = *BLANKS
     C                   EVAL      #1LCUS = *BLANKS
     C                   ENDIF

     C                   IF        #1ACTN = 'A'
     C                   EVAL      #1FCUS = #1FCIR
     C                   EVAL      #1LCUS = #1LCIR
     C                   ENDIF
     C
     C                   ELSE

      ** First Customer in Range validation
      ** -------------------

     C                   IF        #1FCUS = *Blanks

      ** Customer is mandatory

     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7680'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      #1FCUS        @CUST            10
     C                   PARM      *BLANKS       @KEYSTS           7
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        W0RTN <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN41 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0238'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      #1FCUS = BBCUST
     C                   ENDIF
     C                   ENDIF

      ** Last Customer in Range validation
      ** -------------------

     C                   IF        #1LCUS = *Blanks

      ** Customer is mandatory

     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN42 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7680'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      #1LCUS        @CUST            10
     C                   PARM      *BLANKS       @KEYSTS           7
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        W0RTN <> *BLANKS
     C                   EVAL      *IN40 = *ON
     C                   EVAL      *IN42 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0238'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      #1LCUS = BBCUST
     C                   ENDIF
     C                   ENDIF


      ** Check if code already existing on file

     C                   IF        W#EROR = *Blanks

     C                   IF        (#1FCUS <> #1FCIR and
     C                             #1LCUS <> #1LCIR and
     C                             #1ACTN = 'A') or
     C                             (*IN09 = *ON)

     C/EXEC SQL
     C+ SELECT *
     C+ into :CusRangeDS
     C+ from SDCUSRTD
     C+ where CRFCIR = :#1FCUS and
     C+       CRLCIR = :#1LCUS
     C/END-EXEC
     C
     C                   IF        %Subst(SQLState:1:2) <> '02'
     C                   MOVEA     '111'         *IN(40)
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7655'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   IF        W#EROR = *Blanks and
     C                             *IN12 = *OFF and *IN03 = *OFF
     C                             AND *IN05 = *OFF
     C                   IF        #1FCUS > #1LCUS
     C                   MOVEA     '111'         *IN(40)
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR8500'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EXSR      SRScrn2
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Create Customer Range Details                       *
      *                                                               *
      *****************************************************************
     C     SRWrite       BEGSR

     C                   EVAL      W#EROR = *BLANKS

      ** Create Customer Range Data Details

     C     *LIKE         DEFINE    CRTMST        WTIME
     C                   TIME                    WTIME

      ** Check for duplicate primary key

     C/EXEC SQL
     C+ SELECT *
     C+ into :CusRangeDS
     C+ from SDCUSRTD
     C+ where CRFCIR = :#2FCIR and
     C+       CRLCIR = :#2LCIR
     C/END-EXEC

     C                   IF        %Subst(SQLState:1:2) <> '02'
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR0017'
     C                   EXSR      SRZasnms
     C                   ELSE

     C/EXEC SQL
     C+ insert into SDCUSRTD
     C+ (
     C+   CRRECI
     C+ , CRFCIR
     C+ , CRLCIR
     C+ , CRCHGT
     C+ , CRCHGD
     C+ , CRUSER
     C+ , CRTMST
     C+ )
     C+ Values
     C+ (
     C+   'D'
     C+ , :#2FCIR
     C+ , :#2LCIR
     C+ ,  'I'
     C+ , :BJRDNB
     C+ , :PSUser
     C+ , :WTIME
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
      * SRDelete - Delete Customer Range Details                      *
      *                                                               *
      *****************************************************************
     C     SRDelete      BEGSR

      ** Deletion not allowed when system setup is complete

     C                   EVAL      W#EROR = *BLANKS
     C                   IF        WSUC <> 'N'
     C                   EVAL      *IN40 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR4745'
     C                   EXSR      SRZasnms
     C                   ELSE

     C/EXEC SQL
     C+    SELECT *
     C+ into :CusRangeDS
     C+ from SDCUSRTD
     C+ where CRFCIR = :#1FCIR and
     C+       CRLCIR = :#1LCIR
     C/END-EXEC

      ** Record already deleted

     C                   IF        %Subst(SQLState:1:2) = '02'
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7602'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      #2MODE = 'DELETE'

      ** Move to display file fields


     C                   EVAL      #2FCIR = CRFCIR
     C                   EVAL      #2LCIR = CRLCIR

      ** Check if code already existing on file

     C                   EXSR      SRScrn2

      ** Clear messages from program message queue

     C                   CALL      'ZA0250'

      ** Set record data changed flag

     C                   EVAL      WCUST = 'N'

     C                   IF        *IN10 = *ON
     C/EXEC SQL
     C+    SELECT *
     C+ into :CusRangeDS
     C+ from SDCUSRTD
     C+ where CRFCIR = :#1FCIR and
     C+       CRLCIR = :#1LCIR
     C/END-EXEC

      ** Record not found

     C                   If        %Subst(SQLState:1:2) = '02'

     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7605'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   TIME                    WTIME
     C/EXEC SQL
     C+ DELETE from SDCUSRTD
     C+ where CRFCIR = :#1FCIR and
     C+       CRLCIR = :#1LCIR
     C/END-EXEC

     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAmend  - Update Customer Ranges Data Details                *
      *                                                               *
      *****************************************************************
     C     SRAmend       BEGSR

      ** Change Customer Ranges Data Details

     C                   EVAL      W#EROR = *BLANKS

     C                   EXSR      SRScrn2Clr
     C                   EVAL      #1MODE = 'AMEND  '
     C                   EVAL      #1FCUS = #1FCIR
     C                   EVAL      #1LCUS = #1LCIR
     C                   EVAL      *IN37 = *ON
     C                   EXSR      SRValInput

      ** Clear messages from program message queue

     C                   CALL      'ZA0250'

      ** Set record data changed flag

     C                   EVAL      WCUST = 'N'

     C                   IF        W#EROR = *Blanks and *IN12 <> *ON and
     C                             *IN03 <> *ON


      ** Populate file fields.

     C                   TIME                    WTIME

     C/EXEC SQL
     C+ UPDATE SDCUSRTD SET CRCHGD = :BJRDNB, CRCHGT = 'A', CRFCIR = :#2FCIR,
     C+ CRLCIR = :#2LCIR, CRUSER = :PSuser, CRTMST = :WTIME
     C+ where CRFCIR = :#1FCIR and
     C+       CRLCIR = :#1LCIR
     C/END-EXEC

     C                   EVAL      WCUST = 'Y'
     C                   EVAL      W1RSF = 'Y'
     C                   ENDIF

     C                   IF        *IN03 = *ON or *IN12 = *ON
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
      * SRCount - Count number of records in SDCUSRTD                 *
      *                                                               *
      *****************************************************************
     C     SRCount       BEGSR

     C/exec sql
     C+ declare CustRangeCount Cursor with return to client
     C+  for select count(*)
     C+  from SDCUSRTD
     C/end-exec

     C/exec sql
     C+ open CustRangeCount
     C/end-exec

     C/exec SQL
     C+ fetch CustRangeCount
     C+ into :CountRange
     C/end-exec

     C/exec SQL
     C+ close CustRangeCount
     C/end-exec

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Set up copyright parameter

     C                   MOVEA     CPY@          CPY2@

      ** Receive entry parameters

     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    PMODE

      ** Define LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SD000951'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 1
     C                   OUT       LDA

     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT

      ** Obtain default message file

      ** Call Access Program for Bank Details

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSSDY

     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBPGM  = 'SD000951'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF


      ** Open files for update

     C                   OPEN      SD000951DF

     C/exec sql
     C+ declare CustRangeFile Scroll Cursor
     C+  for select *
     C+  from SDCUSRTD
     C+  order by
     C+  CRFCIR, CRLCIR
     C/end-exec

     C/exec sql
     C+ open CustRangeFile
     C/end-exec


     C                   Z-ADD     14            WSFPG

      ** Set to *CHANGE mode

     C                   EVAL      W1PMD = 'CHG'

      ** Initialise subfile control

     C                   EVAL      SPOSN = *BLANKS
     C                   EVAL      #1RUNA = BJMRDT
     C                   EVAL      #1PGMQ = PSProcName
     C                   EVAL      #1WSID = PSJobName
     C                   EVAL      #1USER = PSUser

      ** Initialise subfile control

     C                   MOVEL     *BLANK        #1POS1
     C                   MOVEL     *BLANK        #1POS2

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
     C                   CALLB     'DBERRCTL'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     P*****************************************************************
     P* pSQL_RanOK - See if last SQL statement ran ok.                *
     P*****************************************************************
     P pSQL_RanOk      b
     D pSQL_RanOk      pi              n
     D  iSQLState                     5a   Const

     C                   Return    %Subst(iSQLState:1:2) = '00'
     C                             or %Subst(iSQLState:1:2) = '01'

     P                 e
** CPY@
(c) Finastra International Limited 2018
