     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2023')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Update MEMOS file')                           *
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects Module                                *
      *                                                               *
      *     AOMEMSU1 - Update MEMOS file                              *
      *                                                               *
      *  (c) Finastra International Limited 2023                      *
      *                                                               *
      *  Last Amend No. MD060909 *CREATE   Date 14Feb23               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD060909 - After COB job FTC0630 go in MSGW.                 *
      *           - New program to update MEMOS file for shadow       *
      *             post.                                             *
      *                                                               *
      *****************************************************************
     FGLMEMOL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *****************************************************************
      **
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
      ** +--------------------------------------+
      **----------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **----------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **----------------------------------------------------------------
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
      *
      ** External DS For bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** First DS for Access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Entry parameter
      *
     D PRETURN         S              7A
     D PACNO           S             10P 0
     D PCNUM           S              6A
     D PCCY            S              3A
     D PACOD           S             10P 0
     D PACSQ           S              2P 0
     D PBRCA           S              3A
     D PVDATE          S              5P 0
     D PPDATE          S              5P 0
     D PAMT            S             15P 0
     D PFTOV           S              1A
     D PRTCD           S              7A
     D POPTN           S              7A
      /EJECT
      *****************************************************************
      * MAIN - Main body                                              *
      *****************************************************************
      *
     C                   EVAL      MEACNO = PACNO
     C                   EVAL      MECNUM = PCNUM
     C                   EVAL      MECCY  = PCCY
     C                   EVAL      MEACOD = PACOD
     C                   EVAL      MEACSQ = PACSQ
     C                   EVAL      MEBRCA = PBRCA
     C                   EVAL      MEVDAT = PVDATE
     C                   EVAL      MEPDAT = PPDATE
     C                   EVAL      MEAMT  = PAMT
     C                   EVAL      MEFTOV = PFTOV
     C                   TIME                    METMST
     C                   EVAL      MEPROC = *BLANK
      *
     C                   WRITE(E)  GLMEMOT0
      *
     C                   IF        %ERROR
     C                   EVAL      PRETURN = '*ERROR '
     C                   EVAL      DBFILE  = 'GLMEMOL0'
     C                   EVAL      DBKEY   = PCNUM
     C                   EVAL      DBASE   = 002
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   RETURN
      ****************************************************************
      /EJECT
      ****************************************************************
      * *INZSR - Program Initialisation routine
      ************************************************************
     C     *INZSR        BEGSR
      *
      ***  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      ***  Return Code
      *
     C                   PARM                    PRETURN
      *
      ***  MEMOS keys
      *
     C                   PARM                    PACNO
     C                   PARM                    PCNUM
     C                   PARM                    PCCY
     C                   PARM                    PACOD
     C                   PARM                    PACSQ
     C                   PARM                    PBRCA
      *
      *** Value Date
      *
     C                   PARM                    PVDATE
      *
      *** Posting Date
      *
     C                   PARM                    PPDATE
      *
      *** Amount
      *
     C                   PARM                    PAMT
      *
      *** FT Override LDBL
     C                   PARM                    PFTOV
      *
      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRTCD  <> *BLANKS
     C                   EVAL      PRETURN = '*ERROR '
     C                   EVAL      DBFILE  = 'SDBANKPD'
     C                   EVAL      DBKEY   =  POPTN
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
     ****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
**  CPY@
(c) Finastra International Limited 2023
