     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
      *****************************************************************
/*S*DF***RPGBASE*******************************************************                       CSD053
/*S*D ***RPGBNOCVT*****************************************************              CSD053 MD056543
/*E*S ***RPGCVTOPT1****************************************************              CSD053 MD056543
/*STD *  RPGBASEBND                                                   *                     MD056543
/*EXI *  TEXT('Midas CG UDC print address labels')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3500 - Print address labels                                *
      *                                                               *
      *  Function:  This program prints address labels for any item   *
      *             of correspondence where the destination's 'print  *
      *             label' indication is set.                         *
      *                                                               *
      *  Called By: UDC print process job                             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CCG024             Date 29Sep16               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD053             Date 01Jun06               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. 190022             Date 15Jun99               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01522             Date 15Dec94               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD and CGCDSHPD *
      *             to readable unicode equivalent.                   *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG024 - Use Atlernate Name and Address in Correspondence    *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  190022 - Recompiled due to increased size of OVRPRTF string  *
      *           in PF/CGPRTPPD and PF/CGPGENPD files.               *
      *  S01522 - User Defined Correspondence                         *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Note:                                                         *
      * -----                                                         *
      *                                                               *
      * Label stationery is defined to this program using eight       *
      * numeric parameters (all 5,0) defined in alpha format on       *
      * data area CGDTA, beginning at position 116:                   *
      *                                                               *
      *  o SIZX   - the width of the stationery, in characters.       *
      *  o SIZY   - the length of the stationery, in lines.           *
      *  o NOX    - the number of labels across the page.             *
      *  o NOY    - the number of labels down the page.               *
      *  o MAX    - the left/right margin: the number of characters   *
      *             from the edge of the page to the first label.     *
      *  o MAY    - the top/bottom margin: the number of lines        *
      *             from the top of the page to the first label.      *
      *  o LABX   - the width of each label, in characters.           *
      *  o LABY   - the length of each label, in lines.               *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Indicator usage                                              *
      *  ~~~~~~~~~~~~~~~                                              *
      *                                                               *
      *  01   -    XX                                                 *
      *  50   -    EoF, LF/CGPGENLn Print generator driver            *
      *  55   -    NrF, LF/CGCORRL0 Correspondent details             *
      *  60   -    NrF, LF/SDCUSTL0 Customer details                  *
      *  65   -    NrF, LF/CGUDCRL0 UDC reference                     *
      *                                                               *
      *****************************************************************
      /EJECT
      *
     FCGPGENL2  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     FCGPGENL3  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
     FCGCORRL0  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FCGCORRL4  IF   E           K DISK    INFSR(SRFILE)                                      CCG024
     FCGUDCRL2  IF   E           K DISK
     F                                     INFSR(SRFILE)
     FSDCUSTL0  IF   E           K DISK
     F                                     INFSR(SRFILE)
     F/COPY WNCPYSRC,CG3500F001
     FCG3500P1  O    E             PRINTER INFDS(SPOOLP)
     F                                     USROPN
     F                                     INFSR(SRFILE)
I     /EJECT
      ** Copyright statement
      *
     D**********          @ADA        8 50                                                    CSD053
      ** Address data
      *
     D/COPY WNCPYSRC,CG3500E001
      ** Column of page
      *
     D @X1             S              5  0 DIM(100)
     D @Y1             S              5  0 DIM(100)
     D @X2             S              5  0 DIM(100)
     D @Y2             S              5  0 DIM(100)
      ** Arrays of label co-ordinates on page
      *
      *COPY*CGCPYSRC,SRERRE                                                                 MD056543
      /COPY CGCPYSRC,SRERRDLE                                                               MD056543
      /EJECT
     D CPYR@#          DS
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      ** Copyright statement
      *
     D SPOOLP          DS
     D  PFILE                 83     92
     D  PFNUM                123    124B 0
      **  File information data structure
      *
     D ##KEY           DS
     D  B2ITEM                 1      5P 0
     D  B2DCOR                 6     15
      ** DS for reporting database errors
      *
     D ##ADDR          DS
     D**********                              1  50 ##ADD1                                    CSD053
     D**********                              1  50 CDADD1                                    CSD053
     D**********                              1  35 BBCNA1                                    CSD053
     D**********                             51 100 ##ADD2                                    CSD053
     D**********                             51 100 CDADD2                                    CSD053
     D**********                             51  85 BBCNA2                                    CSD053
     D**********                            101 150 ##ADD3                                    CSD053
     D**********                            101 150 CDADD3                                    CSD053
     D**********                            101 135 BBCNA3                                    CSD053
     D**********                            151 200 ##ADD4                                    CSD053
     D**********                            151 200 CDADD4                                    CSD053
     D**********                            151 185 BBCNA4                                    CSD053
     D**********                            201 250 ##ADD5                                    CSD053
     D**********                            201 250 CDADD5                                    CSD053
     D**********                            251 300 ##ADD6                                    CSD053
     D**********                            251 300 CDADD6                                    CSD053
     D**********                            301 350 ##ADD7                                    CSD053
     D**********                            301 350 CDADD7                                    CSD053
     D**********                            351 400 ##ADD8                                    CSD053
     D**********                            351 400 CDADD8                                    CSD053
     D**********                              1 400 @ADA                                      CSD053
     D  ##ADD1                 1    100                                                       CSD053
     D**CDADD1**               1    100                                              CSD053 MD056543
     D  CDADD1P                1    100                                                     MD056543
     D  BBCNA1                 1     35                                                       CSD053
     D  ##ADD2               101    200                                                       CSD053
     D**CDADD2**             101    200                                              CSD053 MD056543
     D  CDADD2P              101    200                                                     MD056543
     D  BBCNA2               101    135                                                       CSD053
     D  ##ADD3               201    300                                                       CSD053
     D**CDADD3**             201    300                                              CSD053 MD056543
     D  CDADD3P              201    300                                                     MD056543
     D  BBCNA3               201    235                                                       CSD053
     D  ##ADD4               301    400                                                       CSD053
     D**CDADD4**             301    400                                              CSD053 MD056543
     D  CDADD4P              301    400                                                     MD056543
     D  BBCNA4               301    335                                                       CSD053
     D  ##ADD5               401    500                                                       CSD053
     D**CDADD5**             401    500                                              CSD053 MD056543
     D  CDADD5P              401    500                                                     MD056543
     D  ##ADD6               501    600                                                       CSD053
     D**CDADD6**             501    600                                              CSD053 MD056543
     D  CDADD6P              501    600                                                     MD056543
     D  ##ADD7               601    700                                                       CSD053
     D**CDADD7**             601    700                                              CSD053 MD056543
     D  CDADD7P              601    700                                                     MD056543
     D  ##ADD8               701    800                                                       CSD053
     D**CDADD8**             701    800                                              CSD053 MD056543
     D  CDADD8P              701    800                                                     MD056543
     D  @ADA                   1    800                                                       CSD053
     D                                     DIM(8)                                             CSD053
      ** Address fields
      *
     D/COPY WNCPYSRC,CG3500I001
     D ##LINE          DS           200    OCCURS(200)
     D  @C                     1    200
     D                                     DIM(200)
      ** Line of page
      *
     D CGDATA        E DS                  EXTNAME(CGDTA)
      ** Data Area for UDC (used for next item identifier)
      * Data structure for AOSVALR0 string                                                    CCG024
     D                 DS                                                                     CCG024
     D  SVAL1                  1    200                                                       CCG024
     D  SVAL11                 1      1                                                       CCG024
      *                                                                                       CCG024
      * System Value                                                                          CCG024
     D                 DS                                                                     CCG024
     D  SVALK1                 1     20    INZ('RecipientSpecialChar')                        CCG024
      *                                                                                       CCG024
      *
      *COPY*CGCPYSRC,SRERRI                                                                 MD056543
      /EJECT
      *****************************************************************
      *                                                               *
      *   Index to subroutines                                        *
      *   --------------------                                        *
      *                                                               *
      *   SRINIT - Initial processing                                 *
      *   SRREAD - Access next item requiring label                   *
      *   SRPRNT - Print label page                                   *
      *   SRFILL - Fill label with correspondent address              *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Perform initial process
     C                   EXSR      SRINIT
      *
      ** Read the Print Process Driver file
     C                   EXSR      SRREAD
      *
      ** DoWhile not End_of_File
     C     *IN50         DOWEQ     '0'
      *
      ** If this is first record, open printer file
     C     ##FRST        IFEQ      'Y'
     C                   OPEN      CG3500P1
     C                   ENDIF
      *
      ** If change of entity or end of page, output current page. Set
      ** end_of_page indication to ensure page is not printed again
      ** on end_of_file.
     C                   MOVEL     'N'           ##EPAG            1
     C     #SAVBR        IFNE      B2BRCA
     C     ##ENTY        ANDEQ     'Y'
     C     ##FRST        ANDEQ     'N'
     C     #L            OREQ      #C
     C                   EXSR      SRPRNT
     C                   Z-ADD     0             #L
     C                   ENDIF
      *
      ** If change of entity, close and open spool file
     C     #SAVBR        IFNE      B2BRCA
     C     ##ENTY        ANDEQ     'Y'
     C     ##FRST        ANDEQ     'N'
     C                   CLOSE     CG3500P1
     C                   OPEN      CG3500P1
     C                   ENDIF
      *
      ** Access next label
     C                   ADD       1             #L
     C/COPY WNCPYSRC,CG3500C001
      *
      ** Fill next label with this correspondent's address
     C                   EXSR      SRFILL
      *
      ** Read next item
     C                   EXSR      SRREAD
      *
      ** Set off first_item_requiring_label indication
     C                   MOVEL     'N'           ##FRST
      *
      ** EndDoWhile: last record read
     C                   ENDDO
      *
      ** Print final page
     C     ##FRST        IFEQ      'N'
     C                   EXSR      SRPRNT
     C                   ENDIF
      *
     C                   SETON                                        LR
      /EJECT
      *****************************************************************
      * Subroutine  :  SRREAD                                         *
      * Purpose     :  Access next item requiring label               *
      *                                                               *
      * Called by   :  Main process                                   *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SRREAD        BEGSR
      *
      ** Save current branch code
     C                   MOVEL     B2BRCA        #SAVBR            3
      *
      ** Read file until record found for which label is required
     C     *IN50         DOUEQ     '1'
     C     ##RFND        OREQ      'Y'
      *
     C     P#ACCP        IFEQ      'CGPGENL2'
     C                   READ      CGPGENL2                               50
     C                   ELSE
     C/COPY WNCPYSRC,CG3500C005
     C                   READ      CGPGENL3                               50
     C/COPY WNCPYSRC,CG3500C006
     C                   ENDIF
      *
      ** If record found, check whether label is required
     C     *IN50         IFEQ      '0'
      *
      ** Initialise valid_record_found indication
     C                   MOVEL     'Y'           ##RFND            1
      *
      ** Access reference record
     C     K#KEY         CHAIN     CGUDCRL2                           65
      *
      ** Database error if reference not found
     C     *IN65         IFEQ      '1'
     C                   MOVEL     'CGUDCRL2'    W0FILE
     C                   MOVEL     ##KEY         W0KEY                          ***************
     C                   Z-ADD     1             W0ERNB                         * DB ERROR 01 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** If status is not PPFN this is a copy, so no label required
     C     DRISTS        IFNE      'PPFN'
     C                   MOVEL     'N'           ##RFND
     C                   ELSE
      *
      ** If feature CCG024 is on and special character is found in DRDCOR                     CCG024
     C                   MOVEL     'N'           XFOUND            1                          CCG024
     C     CCG024        IFEQ      'Y'                                                        CCG024
     C     SVAL11        SCAN      B2DCOR                                 99                  CCG024
     C     *IN99         IFEQ      *ON                                                        CCG024
     C                   MOVEL     B2DCOR        XXCORR            6                          CCG024
     C     XXCORR        CHAIN     CGCORRL4                           51                      CCG024
     C     *IN51         IFEQ      *ON                                                        CCG024
     C                   MOVEL     'CGCORRL4'    W0FILE                                       CCG024
     C                   MOVEL     B2DCOR        W0KEY                          **************CCG024
     C                   Z-ADD     11            W0ERNB                         * DB ERROR 11 CCG024
     C                   MOVEL     'MEM5004'     W0MSGD                         **************CCG024
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CCG024
     C                   EXSR      SRERR                                                      CCG024
     C                   ENDIF                                                                CCG024
     C                   MOVEL     'Y'           XFOUND                                       CCG024
     C                   ENDIF                                                                CCG024
     C                   ENDIF                                                                CCG024
      *                                                                                       CCG024
     C     XFOUND        IFEQ      'N'
      ** Check whether label required for this destination
      ** correspondent
     C     B2DCOR        CHAIN     CGCORRL0                           55
      *
      ** Database error if correspondent not found
     C     *IN55         IFEQ      '1'
     C                   MOVEL     'CGCORRL0'    W0FILE
     C                   MOVEL     B2DCOR        W0KEY                          ***************
     C                   Z-ADD     2             W0ERNB                         * DB ERROR 02 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF
      *
      ** If 'print label' indication off, set off valid_record_found
     C     CDPLAB        IFNE      'Y'
     C                   MOVEL     'N'           ##RFND
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C/COPY WNCPYSRC,CG3500C002
     C     EXREAD        ENDSR
      /EJECT
      *****************************************************************
      * Subroutine  :  SRFILL                                         *
      * Purpose     :  Fill label with correspondent address          *
      *                                                               *
      * Called by   :  Main process                                   *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SRFILL        BEGSR
      *
      ** If address field from correspondent details is blank, access
      ** customer details
      *                                                                                     MD056543
     C                   EVAL      CDADD1P = *BLANKS                                        MD056543
     C                   EVAL      CDADD2P = *BLANKS                                        MD056543
     C                   EVAL      CDADD3P = *BLANKS                                        MD056543
     C                   EVAL      CDADD4P = *BLANKS                                        MD056543
     C                   EVAL      CDADD5P = *BLANKS                                        MD056543
     C                   EVAL      CDADD6P = *BLANKS                                        MD056543
     C                   EVAL      CDADD7P = *BLANKS                                        MD056543
     C                   EVAL      CDADD8P = *BLANKS                                        MD056543
     C                   EVAL      CDADD1P = CDADD1                                         MD056543
     C                   EVAL      CDADD2P = CDADD2                                         MD056543
     C                   EVAL      CDADD3P = CDADD3                                         MD056543
     C                   EVAL      CDADD4P = CDADD4                                         MD056543
     C                   EVAL      CDADD5P = CDADD5                                         MD056543
     C                   EVAL      CDADD6P = CDADD6                                         MD056543
     C                   EVAL      CDADD7P = CDADD7                                         MD056543
     C                   EVAL      CDADD8P = CDADD8                                         MD056543
      *                                                                                     MD056543
     C     CDADD1        IFEQ      *BLANKS                                                  MD056543
     C                   CLEAR                   ##ADDR
     C     CDCUST        CHAIN     SDCUSTL0                           60
     C                   ENDIF
      *
      ** Fill current label with address information
     C                   Z-ADD     @X1(#L)       #X1
     C                   Z-ADD     @Y1(#L)       #Y1
     C                   Z-ADD     @X2(#L)       #X2
     C                   Z-ADD     @Y2(#L)       #Y2
      *
      ** For each line on the label (but no more than 8)...
     C     #LABY         IFLT      8
     C                   Z-ADD     #LABY         #WYM              5 0
     C                   ELSE
     C                   Z-ADD     8             #WYM
     C                   ENDIF
     C     1             DO        #WYM          #Y
     C     #Y1           ADD       #Y            #WY               5 0
     C     #WY           OCCUR     ##LINE
      *
      ** Get next line of address
     C**********           MOVEA@ADA,#Y   #WK50  50                                           CSD053
     C                   MOVEA     @ADA(#Y)      #WK50           100                          CSD053
      *
      ** If address line non-blank, process
     C     #WK50         IFNE      *BLANKS
      *
      ** For each column...
     C     1             DO        #LABX         #X
     C     #X1           ADD       #X            #WX               5 0
      *
      ** Get next byte of address line and move to page
     C     1             SUBST     #WK50:#X      #WK1              1
     C                   MOVEL     #WK1          @C(#WX)
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C     EXFILL        ENDSR
     C/COPY WNCPYSRC,CG3500C003
      /EJECT
      *****************************************************************
      * Subroutine  :  SRPRNT                                         *
      * Purpose     :  Print page of labels                           *
      *                                                               *
      * Called by   :  Main process                                   *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SRPRNT        BEGSR
      *
      ** Read through page data structure, and write to spool file
     C     #SIZY         SUB       #MAY          #WY
     C     1             DO        #WY           #Y
     C     #Y            OCCUR     ##LINE
     C                   MOVEL     ##LINE        #PLIN
     C                   CLEAR                   ##LINE
      *
      ** Write line of output
     C                   WRITE     CG3500F1
     C                   ENDDO
      *
      ** Throw a page
     C                   WRITE     CG3500F2
      *
     C     EXPRNT        ENDSR
      /EJECT
      *****************************************************************
      * Subroutine  :  SRINIT                                         *
      * Purpose     :  Initial processing                             *
      *                                                               *
      * Called by   :  Main process                                   *
      * Calls       :  -                                              *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Set up copyright statement
     C                   MOVE      CPYR@#        ACT@             80
      *
      ** Entry parameters: return code and member name
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN             7
     C                   PARM                    P#ACCP           10
     C                   PARM                    P#RBCH            3
      *
      ** Key list for CHAIN to CGUDCRL2
     C     K#KEY         KLIST
     C                   KFLD                    B2DCOR                         Destination Cor
     C                   KFLD                    B2ITEM                         Item Identifier
      *
      ** Set entity_level indication from branch parameter: if branch
      ** is 'ALL', need to open and close spool file on change
     C     P#RBCH        IFEQ      'ALL'
     C                   MOVEL     'Y'           ##ENTY            1
     C                   ELSE
     C                   MOVEL     'N'           ##ENTY            1
     C                   ENDIF
      *
      ** Set first_item_requiring_label indication
     C                   MOVEL     'Y'           ##FRST            1
      *
      ** Access data structure for label stationery description
     C     *DTAARA       DEFINE    CGDTA         CGDATA
     C                   IN        CGDATA
      *
      ** Set up program work fields from stored values
     C                   MOVEL     DASIZX        #SIZX             5 0          Page sixe  X
     C                   MOVEL     DASIZY        #SIZY             5 0          Page size  Y
     C                   MOVEL     DANOX         #NOX              5 0          No. labels X
     C                   MOVEL     DANOY         #NOY              5 0          No. labels Y
     C                   MOVEL     DAMAX         #MAX              5 0          Margin     X
     C                   MOVEL     DAMAY         #MAY              5 0          Margin     Y
     C                   MOVEL     DALABX        #LABX             5 0          Label size X
     C                   MOVEL     DALABY        #LABY             5 0          Label size Y
      *
      ** Build arrays of label begin and end co-ordinates, based on
      ** stationery description. Result is 4 arrays (@X1, @X2, @Y1,
      ** @Y2) which describe the top-left, and bottom-right corners
      ** of each label.
      **  o Initialise work variables
     C                   Z-ADD     0             #C                5 0
     C                   Z-ADD     0             #L                5 0
     C                   Z-ADD     0             #X1               5 0
     C                   Z-ADD     0             #Y1               5 0
     C                   Z-ADD     0             #X2               5 0
     C                   Z-ADD     0             #Y2               5 0
      *
      **  o calculate gutter sizes from stationery description
     C     #MAX          MULT      2             #WKMA             5 0
     C     #LABX         MULT      #NOX          #WKLA             5 0
     C     #SIZX         SUB       #WKMA         #GUTX             5 0
     C     #GUTX         SUB       #WKLA         #GUTX
     C     #NOX          IFGT      1
     C     #NOX          SUB       1             #WKNO             5 0
     C     #GUTX         DIV       #WKNO         #GUTX
     C                   ENDIF
      *
     C     #MAY          MULT      2             #WKMA             5 0
     C     #LABY         MULT      #NOY          #WKLA             5 0
     C     #SIZY         SUB       #WKMA         #GUTY             5 0
     C     #GUTY         SUB       #WKLA         #GUTY
     C     #NOY          IFGT      1
     C     #NOY          SUB       1             #WKNO             5 0
     C     #GUTY         DIV       #WKNO         #GUTY
     C                   ENDIF
      *
      **  o Loop, incrementing X and Y, to calculate defining
      **    co-ordinates for every label on the page. Note: #C
      **    will be the total number of labels on a page.
     C     1             DO        #NOX          #X                5 0
     C     #X            IFEQ      1
     C                   Z-ADD     #MAX          #X1
     C                   ELSE
     C     #X2           ADD       #GUTX         #X1
     C                   ENDIF
     C     #X1           ADD       #LABX         #X2
     C     1             DO        #NOY          #Y                5 0
     C     #Y            IFEQ      1
     C                   Z-ADD     #MAY          #Y1
     C                   ELSE
     C     #Y2           ADD       #GUTY         #Y1
     C                   ENDIF
     C     #Y1           ADD       #LABY         #Y2
      *
     C                   ADD       1             #C
      *
     C                   Z-ADD     #X1           @X1(#C)
     C                   Z-ADD     #Y1           @Y1(#C)
     C                   Z-ADD     #X2           @X2(#C)
     C                   Z-ADD     #Y2           @Y2(#C)
      *
     C                   ENDDO
     C                   ENDDO
      *
     C/COPY WNCPYSRC,CG3500C004
      ** Open the relevant access path
     C     P#ACCP        IFEQ      'CGPGENL2'
     C                   OPEN      CGPGENL2
     C                   ELSE
     C/COPY WNCPYSRC,CG3500C007
     C                   OPEN      CGPGENL3
     C/COPY WNCPYSRC,CG3500C008
     C                   ENDIF
      *
      *                                                                                       CCG024
      * Check if CCG024 is switched on                                                        CCG024
     C                   CALL      'AOSARDR0'
     C                   PARM                    P@RTCD            7
     C                   PARM      '*VERIFY'     P@OPTN            7
     C                   PARM      'CCG024'      P@SARD            6
      *                                                                                       CCG024
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CCG024            1
     C                   ELSE
     C                   MOVE      'N'           CCG024
     C                   ENDIF
      *                                                                                       CCG024
      * Check System Value RecipientSpecialChar                                               CCG024
     C     CCG024        IFEQ      'Y'                                                        CCG024
      *                                                                                       CCG024
     C                   CALL      'AOSVALR0'                                                 CCG024
     C                   PARM      *BLANKS       RTNCDE            7                          CCG024
     C                   PARM                    SVALK1           20                          CCG024
     C                   PARM                    SVAL1           200                          CCG024
     C                   PARM      *BLANKS       SVALK2           20                          CCG024
     C                   PARM                    SVAL2           200                          CCG024
     C                   PARM      *BLANKS       SVALK3           20                          CCG024
     C                   PARM                    SVAL3           200                          CCG024
     C                   PARM      *BLANKS       SVALK4           20                          CCG024
     C                   PARM                    SVAL4           200                          CCG024
     C                   PARM      *BLANKS       SVALK5           20                          CCG024
     C                   PARM                    SVAL5           200                          CCG024
     C                   PARM      *BLANKS       SVALK6           20                          CCG024
     C                   PARM                    SVAL6           200                          CCG024
     C                   PARM      *BLANKS       SVALK7           20                          CCG024
     C                   PARM                    SVAL7           200                          CCG024
     C                   PARM      *BLANKS       SVALK8           20                          CCG024
     C                   PARM                    SVAL8           200                          CCG024
     C                   PARM      *BLANKS       SVALK9           20                          CCG024
     C                   PARM                    SVAL9           200                          CCG024
     C                   PARM      *BLANKS       SVALK0           20                          CCG024
     C                   PARM                    SVAL10          200                          CCG024
      *                                                                                       CCG024
     C     RTNCDE        IFNE      *BLANKS                                                    CCG024
     C     SVAL1         IFEQ      '*NRF'                                                     CCG024
     C                   MOVE      SVALK1        DBKEY                                        CCG024
     C                   ENDIF                                                                CCG024
      *                                                                                       CCG024
     C                   MOVEL     'SDSVALR0'    W0FILE                                       CCG024
     C                   MOVEL     '*CALL'       W0KEY                                        CCG024
     C                   Z-ADD     21            W0ERNB                                       CCG024
     C                   MOVEL     'MEM5003'     W0MSGD                                       CCG024
     C                   MOVEL     'MIDAS  '     W0MSGF                                       CCG024
     C                   EXSR      SRERR                                                      CCG024
     C                   ENDIF                                                                CCG024
      *                                                                                       CCG024
     C                   ENDIF                                                                CCG024
      *                                                                                       CCG024
     C     EXINIT        ENDSR
      /EJECT
      *COPY*CGCPYSRC,SRERRC                                                                 MD056543
      *COPY*CGCPYSRC,SRERRPSSR                                                              MD056543
      /COPY CGCPYSRC,SRERRCLE                                                               MD056543
      /COPY CGCPYSRC,SRERRPSSRL                                                             MD056543
**CTDATA CPY@
(c) Finastra International Limited 2001
