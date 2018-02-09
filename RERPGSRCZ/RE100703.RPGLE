     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE I/C Zero Balancing/Sweeping Entry Merge')
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100703 - Input Cycle Zero Balancing/Sweeping Entry merge   *
      *                                                               *
      *  Function:  This program extracts postings/extension records  *
      *             for input cycle zero balancing/sweeping           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 216305             Date 07Apr03               *
      *                 213196             Date 21Jan03               *
      *                 212995             Date 07Jan03               *
      *                 CRE008  *CREATE    Date 04Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  216305 - Fallover in COB caused by deleted hierarchy         *
      *  213196 - Holidays are not checked for top/sweeps             *
      *  212995 - Allow deletion of input cycle sweeps                *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FREICSDL0  UF   E           K DISK    INFSR(*PSSR)
     FREICSIL0  UF   E           K DISK    INFSR(*PSSR)
     FGLPSTTL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTPDF:GLPSTTD0)
     FGLPSTZSL0 UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLAPZSD0: GLPSTZSD0)
 
     FGECXPD    O  A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTPDF:GECXF)
     FGLAPSTZS  O  A E           K DISK    INFSR(*PSSR)
 
      * Input Cycle Zero Balancing/Sweeping Entry merge audit
     FRE100703AUO    E             PRINTER
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      * Cash Management Hierarchy Details                                       216305
     D O_CMHD        E DS                  EXTNAME(RECMHDPD)                    216305
     D A_HIER                  1      9                                         216305
      * Zero Balancing/Sweeping Hierarchy Details                               216305
     D O_ZSHD        E DS                  EXTNAME(REZSHDPD)                    216305
      * Group Account Hierarchy Details                                         216305
     D O_GAHD        E DS                  EXTNAME(REGAHDPD)                    216305
                                                                                216305
                                                                                216305
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
 
      ** File Information Data Structure for RE100703AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs - short data structure
 
 
      /SPACE 5
 
      * Read all input cycle zero balancing/sweeping records
 
     C                   READ      REICSDD0                               60
 
     C     *IN60         DOWEQ     *OFF
                                                                                216305
      *     Access Hierarchy Detail                                             216305
                                                                                216305
     C                   EXSR      ACS_HIER                                     216305
                                                                                216305
      * If hierarchy not present and items are not shadow posted                216305
      *   Delete these items                                                    216305
                                                                                216305
     C     X_RTCD        IFEQ      '*NOREC'                                     216305
     C     IDSPTD        ANDNE     'Y'                                          216305
     C                   MOVEL     'Y'           IDDELD                         216305
     C                   ENDIF                                                  216305
 
      **Delete*the*input*cycle zero balancing/sweeping record                   212995
      *******************                                                       212995
     C*******************DELETE    REICSDD0                                     212995
 
      * Increment counts
 
     C     IDDELD        IFEQ      'Y'
     C                   ADD       1             IDCOUNT
     C                   ELSE
     C     IDSPTD        IFNE      'Y'                                          213196
     C*****IDMTYN********IFNE      'Y'                                          213196
     C                   ADD       1             IUCOUNT
     C                   ELSE
     C                   ADD       1             IPCOUNT
     C                   ENDIF
     C                   ENDIF
                                                                                212995
      * If input cycle zero balancing/sweeping                                  212995
      * is a deletion or is shadow posted                                       213196
      **is*a*deletion*or*is*matched                                      212995 213196
                                                                                212995
     C     IDDELD        IFEQ      'Y'                                          212995
     C     IDSPTD        OREQ      'Y'                                          213196
     C*****IDMTYN********OREQ      'Y'                                   212995 213196
                                                                                212995
      * Delete the input cycle zero balancing/sweeping record                   212995
                                                                                212995
     C                   DELETE    REICSDD0                                     212995
 
      * Read all items for an input cycle zero balancing/sweeping
 
     C                   EXSR      READ_ITEMS
                                                                                212995
     C                   ENDIF                                                  212995
 
      * Read next input cycle zero balancing/sweeping
 
     C                   READ      REICSDD0                               60
     C                   ENDDO
 
      * Write Audit Report
 
     C                   EXSR      AUDIT
 
     C                   SETON                                        LR
     C                   RETURN
 
      *******************************************************************
      /SPACE 5                                                                  216305
      ********************************************************************      216305
      * Access Hierarchy Detail                                                 216305
      ********************************************************************      216305
     C     ACS_HIER      BEGSR                                                  216305
                                                                                216305
     C                   CALLB     'RE100601'                                   216305
      * Return code                                                             216305
      * Error Message                                                           216305
     C                   PARM      *BLANK        X_RTCD                         216305
     C                   PARM      *BLANK        X_ERMS                         216305
      * Option                                                                  216305
     C                   PARM      '*ALL   '     X_OPTN            7            216305
      * Hierarchy ID                                                            216305
     C                   PARM      IDHIER        I_HIER            9 0          216305
      * Hierarchy Type                                                          216305
     C                   PARM      *BLANK        I_HTYP            2            216305
                                                                                216305
     C                   PARM                    O_CMHD                         216305
     C                   PARM                    O_ZSHD                         216305
     C                   PARM                    O_GAHD                         216305
                                                                                216305
      * End if error occurred in module                                         216305
                                                                                216305
     C     X_RTCD        IFEQ      '*ERROR'                                     216305
     C                   EVAL      X_ERMS = 'BAD HIERARCHY DETAIL:' + A_HIER    216305
     C                   EXSR      *PSSR                                        216305
     C                   ENDIF                                                  216305
                                                                                216305
     C                   ENDSR                                                  216305
      *******************************************************************       216305
      /SPACE 5
      ********************************************************************
      * Read all items for an input cycle zero balancing/sweeping
      ********************************************************************
     C     READ_ITEMS    BEGSR
 
      * For each input cycle zero balancing/sweeping, access related item(s)
 
     C     ICZBK         SETLL     REICSID0
     C     ICZBK         READE     REICSID0                               60
 
      * For each item
 
     C     *IN60         DOWEQ     *OFF
 
      * Delete the item record
 
     C                   DELETE    REICSID0
 
      * Get 'posting in transit'
      * (If no record is found, it's a database error)
 
     C     POSTK         CHAIN     GLPSTTD0                           60
     C     *IN60         IFEQ      *ON
     C                   MOVE      IIXRFN        WERMS
     C                   EVAL      X_ERMS = 'No GLPSTTPD for ' + %TRIML(WERMS)
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Delete 'posting in transit'
 
     C                   DELETE    GLPSTTD0
 
      * If input cycle zero balancing/sweeping is NOT a deletion
      **and*is*matched                                                          212995
      *   Write the posting to the generated entries file
 
     C     IDDELD        IFNE      'Y'
     C*****IDMTYN********ANDEQ     'Y'                                          212995
     C                   Z-ADD     BJRDNB        PSTD
     C                   WRITE     GECXF
     C                   ADD       1             PCOUNT
     C                   ENDIF
 
      * Get 'posting in transit' extension
      * (If no record is found, it's a database error)
 
     C     POSTK         CHAIN     GLPSTZSD0                          60
     C     *IN60         IFEQ      *ON
     C                   MOVE      IIXRFN        WERMS
     C                   EVAL      X_ERMS = 'No GLPSTZSPD for ' + %TRIML(WERMS)
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * Delete 'posting in transit' extension
 
     C                   DELETE    GLPSTZSD0
 
      * If input cycle zero balancing/sweeping is NOT a deletion
      **and*is*matched                                                          212995
      *   Write the extension to the extension file
 
     C     IDDELD        IFNE      'Y'
     C*****IDMTYN********ANDEQ     'Y'                                          212995
     C                   WRITE     GLAPZSD0
     C                   ENDIF
 
      * Read the next item
 
     C     ICZBK         READE     REICSID0                               60
     C                   ENDDO
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * AUDIT - Write Audit Report.
      ********************************************************************
     C     AUDIT         BEGSR
 
      * Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSErr
 
      ** If Error occurs during ZSFILE processing, then end abnormally
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   WRITE     HEADAU
     C                   WRITE     DETAILAU
      *
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C                   Z-ADD     0             IDCOUNT           9 0
     C                   Z-ADD     0             IUCOUNT           9 0
     C                   Z-ADD     0             IPCOUNT           9 0
     C                   Z-ADD     0             PCOUNT            9 0
 
     C                   MOVEL     *BLANKS       WERMS            10
 
     C                   MOVEL     'ZS '         ZSRFI             3
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
 
      ** Key to Input Cycle Zero Balancing/Sweeping Items.
     C     ICZBK         KLIST
     C                   KFLD                    IDHIER
     C                   KFLD                    IDLINK
     C                   KFLD                    IDPRCD
     C                   KFLD                    IDSNUM
 
      * Key to related postings/extensions.
     C     POSTK         KLIST
     C                   KFLD                    ZSRFI
     C                   KFLD                    IIXRFN
      *
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
